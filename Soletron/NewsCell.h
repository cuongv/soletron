//
//  NewsCell.h
//  Soletron
//
//  Created by CuongV on 8/20/11.
//  Copyright 2011 HABOI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsCell : UITableViewCell {

    UITextView *txtTitle;
    UITextView *txtDescripton;
    UIImageView *imgImage;
    UIView *view;
    

}


@property (nonatomic, retain) IBOutlet UITextView *txtTitle;
@property (nonatomic, retain) IBOutlet UITextView *txtDescripton;
@property (nonatomic, retain) IBOutlet UIImageView *imgImage;
@property (nonatomic, retain) IBOutlet UIView *view;


@end
