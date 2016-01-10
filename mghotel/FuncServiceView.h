//
//  FuncServiceView.h
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuncServiceView : UIView

@property (strong, nonatomic) IBOutlet UIView *BillRow;
@property (strong, nonatomic) IBOutlet UIView *FoodRow;
@property (strong, nonatomic) IBOutlet UIView *KeyRow;
@property (strong, nonatomic) IBOutlet UIButton *checkInButton;

+ (FuncServiceView *)setupServiceView;

@end
