//
//  RSSViewController.m
//  Soletron
//
//  Created by CuongV on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "RSSEntry.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"
#import "WebViewController.h"

@interface UITextView(HTML)
- (void)setContentToHTMLString:(id)fp8;
@end


@implementation NewsViewController
@synthesize tblNews;
@synthesize allEntries = _allEntries;
@synthesize feeds = _feeds;
@synthesize queue = _queue;
@synthesize webViewController = _webViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)refresh {
    
    for (NSString *feed in _feeds) {
        NSURL *url = [NSURL URLWithString:feed];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [_queue addOperation:request];
    }
    
}

- (void)addRows {
    
    RSSEntry *entry1 = [[[RSSEntry alloc] initWithBlogTitle:@"1" 
                                               articleTitle:@"1" 
                                                 articleUrl:@"1" 
                                                articleDate:[NSDate date] description:@"1" imageURL:@"1"] autorelease];
    RSSEntry *entry2 = [[[RSSEntry alloc] initWithBlogTitle:@"2" 
                                               articleTitle:@"2" 
                                                 articleUrl:@"2" 
                                                articleDate:[NSDate date] description:@"2" imageURL:@"2"] autorelease];
    RSSEntry *entry3 = [[[RSSEntry alloc] initWithBlogTitle:@"3" 
                                               articleTitle:@"3" 
                                                 articleUrl:@"3" 
                                                articleDate:[NSDate date] description:@"3" imageURL:@"3"] autorelease];
    
    
    [_allEntries insertObject:entry1 atIndex:0];
    [_allEntries insertObject:entry2 atIndex:0];
    [_allEntries insertObject:entry3 atIndex:0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    //self.title = @"News";
    //    UIImage *banner = [UIImage imageNamed:@"BannerTopNews.png"];
    //    UIImageView *bannerView = [[UIImageView alloc] initWithImage:banner];
    //    
    //    bannerView.frame = CGRectMake(0, -50, 320, 100);
    //    [self.view addSubview:bannerView];
    //    [self.view bringSubviewToFront:bannerView];
    
    //    self.navigationItem.titleView =  bannerView;
    //    self.navigationItem.titleView.frame = CGRectMake(0, 0, 400, 44);
    
    //Add delegate table route
    tblNews.delegate = self;
    tblNews.dataSource = self;
    
    arrayImageNews = [[NSMutableArray alloc] init];
    
    self.allEntries = [NSMutableArray array];
    self.queue = [[[NSOperationQueue alloc] init] autorelease];
    self.feeds = [NSArray arrayWithObjects:@"http://feeds.feedburner.com/SoletronRSS",nil]; // http://soletron.com/?feed=hottest-drops  for 5 hot product
    [self refresh];
}

- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    NSArray *channels = [rootElement elementsForName:@"channel"];
    //NSLog(@"%@",channels);
    for (GDataXMLElement *channel in channels) {            
        //NSLog(@"%@",channels);
        NSString *blogTitle = [channel valueForChild:@"title"];                    
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            //NSLog(@"%@",item);
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrl = [item valueForChild:@"link"];            
            NSString *articleDateString = [item valueForChild:@"pubDate"];
            NSString *description = [item valueForChild:@"description"];

            NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];
            
            //Get image in Content
            NSString *content  = [item valueForChild:@"content:encoded"];
            NSError * error = nil;
            HTMLParser * parser = [[HTMLParser alloc]  initWithString:content error:&error];
            
            if (error) {
                NSLog(@"Error: %@", error);
                return;
            }
            NSString *imageUrl;
            HTMLNode * bodyNode = [parser body]; //Find the body tag
            NSArray * imageNodes = [bodyNode findChildTags:@"img"]; //Get all the <img alt="" />
            for (HTMLNode * imageNode in imageNodes) { //Loop through all the tags
                NSLog(@"Found image with src: %@", [imageNode getAttributeNamed:@"src"]); //Echo the src=""
                imageUrl = [imageNode getAttributeNamed:@"src"];
                break;
                
            }
            [parser release];
            //////////////////////////
            
            
            RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:blogTitle 
                                                      articleTitle:articleTitle 
                                                        articleUrl:articleUrl 
                                                       articleDate:articleDate description:description imageURL:imageUrl] autorelease];
            [entries addObject:entry];
            NSLog(@"%@",description);
            
            
        }      
    }
    
}

- (void)parseAtom:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSString *blogTitle = [rootElement valueForChild:@"title"];                    
    
    NSArray *items = [rootElement elementsForName:@"entry"];
    for (GDataXMLElement *item in items) {
        
        NSString *articleTitle = [item valueForChild:@"title"];
        NSString *articleUrl = nil;
        NSString *description = [item valueForChild:@"description"];
        NSArray *links = [item elementsForName:@"link"];        
        for(GDataXMLElement *link in links) {
            NSString *rel = [[link attributeForName:@"rel"] stringValue];
            NSString *type = [[link attributeForName:@"type"] stringValue]; 
            if ([rel compare:@"alternate"] == NSOrderedSame && 
                [type compare:@"text/html"] == NSOrderedSame) {
                articleUrl = [[link attributeForName:@"href"] stringValue];
            }
        }
        
        NSString *articleDateString = [item valueForChild:@"updated"];        
        NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC3339];
        
        //Get image in Content
        NSString *content  = [item valueForChild:@"content:encoded"];
        NSError * error = nil;
        HTMLParser * parser = [[HTMLParser alloc]  initWithString:content error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        NSString *imageUrl;
        HTMLNode * bodyNode = [parser body]; //Find the body tag
        NSArray * imageNodes = [bodyNode findChildTags:@"img"]; //Get all the <img alt="" />
        for (HTMLNode * imageNode in imageNodes) { //Loop through all the tags
            NSLog(@"Found image with src: %@", [imageNode getAttributeNamed:@"src"]); //Echo the src=""
            imageUrl = [imageNode getAttributeNamed:@"src"];
            break;
            
        }
        [parser release];
        //////////////////////////

        
        RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:blogTitle 
                                                  articleTitle:articleTitle 
                                                    articleUrl:articleUrl 
                                                   articleDate:articleDate description:description imageURL:imageUrl] autorelease];
        [entries addObject:entry];
        NSLog(@"%@",entry);
        
    }      
    
}

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {    
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) {
        [self parseRss:rootElement entries:entries];
    } else if ([rootElement.name compare:@"feed"] == NSOrderedSame) {                       
        [self parseAtom:rootElement entries:entries];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }    

}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) { 
            NSLog(@"Failed to parse %@", request.url);
        } else {
            
            NSMutableArray *entries = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:entries];                
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                for (RSSEntry *entry in entries) {
                    
//                    //Image
//                    //Request to get image destination
//                    NSURL *urlDestination = [NSURL URLWithString:entry.imageURL];
//                    NSLog(@"%@",entry.imageURL);
//                    __block ASIHTTPRequest *requestImageDestination = [ASIHTTPRequest requestWithURL:urlDestination];
//                    [requestImageDestination setCompletionBlock:^{
//                        // Use when fetching text data
//                        //NSString *responseString = [request responseString];
//                                                // Use when fetching binary data
//                        NSData *responseData = [requestImageDestination responseData];
//                        UIImage *myimage = [[UIImage alloc] initWithData:responseData];
//                        
//                        [arrayImageNews addObject:myimage];
//                        [myimage release];

                        
                        int insertIdx = [_allEntries indexForInsertingObject:entry sortedUsingBlock:^(id a, id b) {
                            RSSEntry *entry1 = (RSSEntry *) a;
                            RSSEntry *entry2 = (RSSEntry *) b;
                            return [entry1.articleDate compare:entry2.articleDate];
                        }];
                        

                        
                        [_allEntries insertObject:entry atIndex:insertIdx];
                        [self.tblNews insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIdx inSection:0]]
                                            withRowAnimation:UITableViewRowAnimationRight];

                        
//                    }];
//                    [requestImageDestination setFailedBlock:^{
//                        NSError *error = [requestImageDestination error];
//                        NSLog(@"Error load image destination : %@",error);
//                        NSLog(@"image URL:%@",entry.imageURL);
//                    }];
//                    [requestImageDestination startAsynchronous];

                    
                                        
                }                            
                
            }];
            
        }        
    }];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allEntries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewsCell";
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[NewsCell class]])
            {
                cell = (NewsCell *)currentObject;
                break;
            }
        }
        
        
        //        cell = [[[NewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 2.0f, 280.0f, 15.0f)];
//		textView.editable = NO;
//		textView.scrollEnabled = NO;
//		textView.opaque = YES;
//		textView.backgroundColor = [UIColor whiteColor];
//		textView.tag = 1;
//		[cell addSubview:textView];
//        [textView release];
//		
//		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    
    //Description
    [cell.txtDescripton setContentToHTMLString:entry.description];
    cell.txtDescripton.backgroundColor = [UIColor clearColor];
    cell.txtDescripton.textColor = [UIColor colorWithRed:105.0/255.0 green:106.0/255.0 blue:105.0/255.0  alpha:1];
    //Title
    cell.txtTitle.textColor = [UIColor colorWithRed:112.0/255.0 green:209.0/255.0 blue:7.0/255.0 alpha:1];
    cell.txtTitle.font = [UIFont boldSystemFontOfSize:14];
    [cell.txtTitle setContentToHTMLString:entry.articleTitle];
    cell.txtTitle.backgroundColor = [UIColor clearColor];
    
   // cell.imgImage.image = [arrayImageNews objectAtIndex:indexPath.row];
    
//    //Image
//    //Request to get image destination
//    NSURL *urlDestination = [NSURL URLWithString:entry.imageURL];
//    NSLog(@"%@",entry.imageURL);
//    __block ASIHTTPRequest *requestImageDestination = [ASIHTTPRequest requestWithURL:urlDestination];
//    [requestImageDestination setCompletionBlock:^{
//        // Use when fetching text data
//        //NSString *responseString = [request responseString];
//        
//        // Use when fetching binary data
//        NSData *responseData = [requestImageDestination responseData];
//        UIImage *myimage = [[UIImage alloc] initWithData:responseData];
//        
//        cell.imgImage.image = myimage;
//    }];
//    [requestImageDestination setFailedBlock:^{
//        NSError *error = [requestImageDestination error];
//        NSLog(@"Error load image destination : %@",error);
//        NSLog(@"image URL:%@",entry.imageURL);
//    }];
//    [requestImageDestination startAsynchronous];
    
    
    
    
//    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
//    
//    cell.textLabel.text = entry.articleTitle; 
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
//    cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:209.0/255.0 blue:7.0/255.0 alpha:1];
//
//    cell.imageView.image = [UIImage imageNamed:@"lion.png"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", entry.description];
//    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + 100);
//    
//    
//    UITextView *textView = (UITextView *)[cell viewWithTag:1];
//    NSString* stringWithHtml = [NSString stringWithFormat:@"%@",entry.description];
//	[textView setContentToHTMLString:stringWithHtml];

    
    return cell;
}

//Change height of table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 73;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (_webViewController == nil) {
        self.webViewController = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]] autorelease];
    }
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    _webViewController.entry = entry;
    //[self.navigationController pushViewController:_webViewController animated:YES];
    [self.view addSubview:_webViewController.view];
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    self.webViewController = nil;
}

- (void)viewDidUnload {
    [self setTblNews:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [arrayImageNews release];
    [_allEntries release];
    _allEntries = nil;
    [_queue release];
    _queue = nil;
    [_feeds release];
    _feeds = nil;
    [_webViewController release];
    _webViewController = nil;
    [tblNews release];
    [super dealloc];
}


@end

