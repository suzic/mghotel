//
//  UISuzicImageView.m
//  mghotel
//
//  Created by 苏智 on 16/1/26.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "UISuzicImageView.h"

@implementation UISuzicImageView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 1, NULL, kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [self.image drawAtPoint:CGPointMake(-point.x, -point.y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0f;
    BOOL transparent = alpha < 0.1f;
    
    return !transparent;
}
@end
