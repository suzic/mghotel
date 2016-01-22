//
//  PresentRootController.m
//  mghotel
//
//  Created by 苏智 on 16/1/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "PresentRootController.h"

@implementation PresentRootController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
