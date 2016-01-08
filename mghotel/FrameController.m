//
//  FrameController.m
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FrameController.h"

@interface FrameController ()

@property (strong, nonatomic) IBOutlet UIView *settingsFrame;

@property (strong, nonatomic) IBOutlet UIView *fliterFrame;

@property (strong, nonatomic) IBOutlet UIView *mainFrame;
@property (strong, nonatomic) UINavigationController *mainNaviController;


@end

@implementation FrameController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.mainNaviController.topViewController.supportedInterfaceOrientations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainEmbed"])
    {
        self.mainNaviController = [segue destinationViewController];
    }
}

@end
