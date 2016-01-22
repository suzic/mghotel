//
//  MainController.h
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuncReservationView.h"
#import "FuncServiceView.h"

@interface MainController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *funcReservation;
@property (strong, nonatomic) IBOutlet UILabel *funcNavigation;
@property (strong, nonatomic) IBOutlet UILabel *funcService;

@property (strong, nonatomic) IBOutlet UIView *filterService;
@property (strong, nonatomic) IBOutlet UIView *filterShop;
@property (strong, nonatomic) IBOutlet UIView *filterFood;

@property (strong, nonatomic) IBOutlet UIView *funcNavigationView;
@property (retain, nonatomic) FuncReservationView *funcReservationView;
@property (retain, nonatomic) FuncServiceView *funcServicenView;

@property (strong, nonatomic) IBOutlet UIView *worldLayer;

@end
