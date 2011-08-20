//
//  NewsCell.m
//  Soletron
//
//  Created by CuongV on 8/20/11.
//  Copyright 2011 HABOI. All rights reserved.
//

#import "NewsCell.h"


@implementation NewsCell


@synthesize txtTitle;
@synthesize txtDescripton;
@synthesize imgImage;
@synthesize view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [txtTitle release];
    [txtDescripton release];
    [imgImage release];
    [view release];
    [super dealloc];
}

@end
