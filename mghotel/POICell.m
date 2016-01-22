//
//  POICell.m
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "POICell.h"

@interface POICell ()

@property (strong, nonatomic) IBOutlet UIView *CardBackgroud;


@end

@implementation POICell

- (void)awakeFromNib
{
    // Initialization code
    self.CardBackgroud.layer.borderWidth = 0.5f;
    self.CardBackgroud.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.SnailImage.layer.borderWidth = 4.0f;
    self.SnailImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    CGAffineTransform trans = CGAffineTransformIdentity;
    trans = CGAffineTransformRotate(trans, -M_PI / 18);
    self.SnailImage.transform = trans;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)findLocation:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowMap object:sender];
}

@end
