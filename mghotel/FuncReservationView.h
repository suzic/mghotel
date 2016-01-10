//
//  FuncReservationView.h
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuncReservationView : UIView

@property (strong, nonatomic) IBOutlet UIView *ARTRow;
@property (strong, nonatomic) IBOutlet UIView *CRSRow;
@property (strong, nonatomic) IBOutlet UIView *CenterView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

+ (FuncReservationView *)setupReservationView;

@end
