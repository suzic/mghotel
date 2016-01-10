//
//  FuncServiceView.m
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FuncServiceView.h"

@interface FuncServiceView ()

@property (strong, nonatomic) IBOutlet UIView *callRow;
@property (strong, nonatomic) IBOutlet UIView *checkInRow;
@property (strong, nonatomic) IBOutlet UIView *checkInIcon;

@end

@implementation FuncServiceView

+ (FuncServiceView *)setupServiceView
{
    NSArray *viewsArray = [[NSBundle mainBundle] loadNibNamed:@"FunctionViews" owner:nil options:nil];
    for (UIView *view in viewsArray)
    {
        if ([view isKindOfClass:[FuncServiceView class]])
            return (FuncServiceView *)view;
    }
    return nil;
}

- (void)awakeFromNib
{
    self.callRow.layer.cornerRadius = 8.0f;
    self.BillRow.layer.cornerRadius = 8.0f;
    self.FoodRow.layer.cornerRadius = 8.0f;
    self.KeyRow.layer.cornerRadius = 8.0f;
    self.checkInIcon.layer.cornerRadius = 32.0f;
    self.checkInButton.layer.cornerRadius = 8.0f;
    
    self.callRow.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.BillRow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.FoodRow.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.KeyRow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // self.checkInIcon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // self.checkInButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.callRow.layer.borderWidth = 0.5f;
    self.BillRow.layer.borderWidth = 0.5f;
    self.FoodRow.layer.borderWidth = 0.5f;
    self.KeyRow.layer.borderWidth = 0.5f;
    // self.checkInIcon.layer.borderWidth = 0.5f;
    // self.checkInButton.layer.borderWidth = 0.5f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
