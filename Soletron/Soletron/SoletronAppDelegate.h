//
//  SoletronAppDelegate.h
//  Soletron
//
//  Created by CuongV on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Top5ViewController.h"
#import "ForumViewController.h"
#import "StoreViewController.h"
#import "NewsViewController.h"

@class SoletronViewController;
@class SoletronAppDelegate; 

extern SoletronAppDelegate* soletronAppDelegate;

@interface SoletronAppDelegate : NSObject <UIApplicationDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SoletronViewController *viewController;

@end
