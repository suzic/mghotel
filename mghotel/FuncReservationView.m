//
//  FuncReservationView.m
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FuncReservationView.h"

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
