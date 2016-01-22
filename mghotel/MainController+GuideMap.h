//
//  MainController+GuideMap.h
//  mghotel
//
//  Created by 苏智 on 16/1/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface MainController (GuideMap)

- (void)setupWorldLayer;

- (void)resizeWorldLayer;

- (void)focusTarget:(UIGestureRecognizer *)sender;

@end
