//
//  FuncReservationView.m
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FuncReservationView.h"

@interface FuncReservationView()

@property (strong, nonatomic) IBOutlet UIView *searchRow;
@property (strong, nonatomic) IBOutlet UIView *searchIcon;

@end

@implementation FuncReservationView

+ (FuncReservationView *)setupReservationView
{
    NSArray *viewsArray = [[NSBundle mainBundle] loadNibNamed:@"FunctionViews" owner:nil options:nil];
    for (UIView *view in viewsArray)
    {
        if ([view isKindOfClass:[FuncReservationView class]])
            return (FuncReservationView *)view;
    }
    return nil;
}

- (void)awakeFromNib
{
    self.ARTRow.layer.cornerRadius = 8.0f;
    self.CRSRow.layer.cornerRadius = 8.0f;
    self.CenterView.layer.cornerRadius = 8.0f;
    self.searchIcon.layer.cornerRadius = 24.0f;
    self.searchButton.layer.cornerRadius = 8.0f;
    
    self.ARTRow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.CRSRow.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.CenterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.searchIcon.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.searchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.ARTRow.layer.borderWidth = 0.5f;
    self.CRSRow.layer.borderWidth = 0.5f;
    self.CenterView.layer.borderWidth = 0.5f;
//    self.searchIcon.layer.borderWidth = 0.5f;
//    self.searchButton.layer.borderWidth = 0.5f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
