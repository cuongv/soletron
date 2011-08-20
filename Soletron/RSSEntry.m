//
//  RSSEntry.m
//  RSSFun
//
//  Created by Ray Wenderlich on 1/24/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize articleDate = _articleDate;
@synthesize description= _description;
@synthesize imageURL = _imageURLl;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate description:(NSString*) description imageURL:(NSString*)imageURL;
{
    if ((self = [super init])) {
        _blogTitle = [blogTitle copy];
        _articleTitle = [articleTitle copy];
        _articleUrl = [articleUrl copy];
        _articleDate = [articleDate copy];
        _description = [description copy];
        _imageURL = imageURL;
    }
    return self;
}

- (void)dealloc {
    [_blogTitle release];
    _blogTitle = nil;
    [_articleTitle release];
    _articleTitle = nil;
    [_articleUrl release];
    _articleUrl = nil;
    [_articleDate release];
    _articleDate = nil;
    [_description release];
    _description = nil;
    [_imageURL release];
    _imageURL = nil;
    [super dealloc];
}

@end