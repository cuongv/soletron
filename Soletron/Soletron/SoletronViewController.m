//
//  SoletronViewController.m
//  Soletron
//
//  Created by CuongV on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoletronViewController.h"

@implementation SoletronViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnStartClick:(id)sender {

    //Init new NewsViewController
    NewsViewController *newView = [[NewsViewController alloc] init];
    
    //Init new Top 5 ViewController
     Top5ViewController *top5View = [[Top5ViewController alloc] init];

    //Init Forum controller
    ForumViewController* forumView = [[ForumViewController alloc] init];
    UINavigationController* navForum = [[UINavigationController alloc] initWithRootViewController:forumView];
    
    //Init Store Viewcontroller
    StoreViewController *storeViewController = [[StoreViewController alloc] init];
    //UINavigationController *navStore = [[UINavigationController alloc] initWithRootViewController:storeViewController];

    UIBarButtonItem* btnLogin = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonSystemItemAction target:self action:@selector(btnLoginClick:)];
    forumView.navigationItem.rightBarButtonItem = btnLogin;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(0, 0, 100, 50);
//    [btn setTitle:@"list" forState:UIControlStateNormal];
//    self.navigationItem.titleView = btn; 
//    
//    forumView.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
//    forumView.navigationItem.titleView =btn;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:newView];
    [array addObject:top5View];
    [array addObject:navForum];
    [array addObject:storeViewController];
    
    UITabBarController* tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = array;
    [[tabBar.tabBar.items objectAtIndex:0] setTitle:@"News"];
    [[tabBar.tabBar.items objectAtIndex:1] setTitle:@"Top 5"];
    [[tabBar.tabBar.items objectAtIndex:2] setTitle:@"Forum"];
    [[tabBar.tabBar.items objectAtIndex:3] setTitle:@"Store"];
    [array release];
    
    soletronAppDelegate.window.rootViewController = tabBar;
    
    [newView release];
    [top5View release];
    [forumView release];
    [storeViewController release];
    //[navRSS release];
    [navForum release];
      
}
@end
