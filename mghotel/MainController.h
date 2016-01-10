//
//  MainController.h
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuncReservationView.h"

@interface MainController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *funcReservation;
@property (strong, nonatomic) IBOutlet UILabel *funcNavigation;
@property (strong, nonatomic) IBOutlet UILabel *funcService;

@property (retain, nonatomic) FuncReservationView *funcReservationView;
@property (retain, nonatomic) FuncReservationView *funcNavigationView;
@property (retain, nonatomic) FuncReservationView *funcServicenView;

@property (assign, nonatomic) BOOL showFunctionLayer;

@end
