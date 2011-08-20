//
//  NewsViewController.h
//  Soletron
//
//  Created by CuongV on 8/19/11.
//  Copyright 2011 HABOI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSEntry.h"
#import "NewsCell.h"
#import "HTMLParser.h"

@class WebViewController;

@interface NewsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    NSOperationQueue *_queue;
    NSArray *_feeds;
    NSMutableArray *_allEntries;
    WebViewController *_webViewController;
    UITableView *tblNews;
    NSMutableArray *arrayImageNews;
}
@property (nonatomic, retain) IBOutlet UITableView *tblNews;
@property (retain) NSOperationQueue *queue;
@property (retain) NSArray *feeds;
@property (retain) NSMutableArray *allEntries;
@property (retain) WebViewController *webViewController;

- (void)refresh;
@end
