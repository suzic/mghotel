//
//  MainController+GuideMap.m
//  mghotel
//
//  Created by 苏智 on 16/1/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MainController+GuideMap.h"
#import "UISuzicImageView.h"
#import "OBShapedButton.h"

@implementation MainController (GuideMap)

- (void)setupWorldLayer
{
    for (int index = 0; index < 13; index++)
    {
        CGRect focusFrame = CGRectMake(0, 0, self.worldLayer.frame.size.width, self.worldLayer.frame.size.height);
        UIImageView *oneFocus = [[UIImageView alloc] initWithFrame:focusFrame];
        NSString *imageName = [NSString stringWithFormat:@"wl_%d", index];
        [oneFocus setImage:[UIImage imageNamed:imageName]];
        oneFocus.clearsContextBeforeDrawing = YES;
        oneFocus.contentMode = UIViewContentModeScaleAspectFit;
        [self.worldLayer addSubview:oneFocus];
        //oneFocus.hidden = YES;
    }
    
    UITapGestureRecognizer *tapTarget = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTarget:)];
    [self.worldLayer addGestureRecognizer:tapTarget];
}

- (void)resizeWorldLayer
{
    for (UIImageView *imageView in self.worldLayer.subviews)
    {
        CGRect focusFrame = CGRectMake(0, 0, self.worldLayer.frame.size.width, self.worldLayer.frame.size.height);
        [imageView setFrame:focusFrame];
    }
}

// 测试点击热点区域
- (void)focusTarget:(UIGestureRecognizer *)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//    tap.view.hidden = YES;
//    return;
    CGPoint pt = [tap locationInView:self.worldLayer];
    
    for (UIImageView* imageView in self.worldLayer.subviews)
    {
        if ([self point:pt insideImageView:imageView])
            imageView.hidden = YES;
    }
}

// 根据图片透明特性来判断是否点击到图片中的内容
- (BOOL)point:(CGPoint)point insideImageView:(UIImageView *)imageView
{
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 1, NULL, kCGImageAlphaOnly);
    //UIGraphicsPushContext(context);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [imageView.layer renderInContext:context];
    //UIGraphicsPopContext();
    CGFloat alpha = pixel[0] / 255.0f;
    CGContextRelease(context);
    
    BOOL transparent = alpha < 0.1f;
    return !transparent;
}

@end
