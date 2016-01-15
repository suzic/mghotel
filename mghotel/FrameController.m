//
//  FrameController.m
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "FrameController.h"
#import "SettingsController.h"
#import "MainController.h"

@interface FrameController ()

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UIView *layerMaskMain;
@property (nonatomic, strong) UIView *layerMaskSetting;

@property (strong, nonatomic) IBOutlet UIView *settingsFrame;
@property (strong, nonatomic) IBOutlet UIView *fliterFrame;
@property (strong, nonatomic) IBOutlet UIView *mainFrame;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingsWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainContainerX;

@property (retain, nonatomic) UINavigationController *mainNaviController;
@property (retain, nonatomic) MainController *mainController;
@property (retain, nonatomic) SettingsController *settingsController;

@end

@implementation FrameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationName = @"三亚・三亚湾";
    
    // 默认初始化除了主容器以外的层都隐藏
    self.mainFrame.hidden = NO;
    self.fliterFrame.hidden = YES;
    self.settingsFrame.hidden = YES;
    
    // 修饰阴影
    self.mainFrame.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainFrame.layer.shadowOffset = CGSizeMake(-5, 0);
    self.mainFrame.layer.shadowOpacity = 0.5;
    self.mainFrame.layer.shadowRadius = 3;
    
    // 创建一个遮罩层，用于主体视图位于非激活状态时遮罩内容，并可以响应点击恢复主视图的手势功能
    self.layerMaskMain = [[UIView alloc] initWithFrame:self.mainFrame.frame];
    [self.mainFrame addSubview:self.layerMaskMain];
    [self.layerMaskMain setHidden:YES];
    [self.layerMaskMain setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.layerMaskMain addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.layerMaskMain addGestureRecognizer:panGesture];
    
    // 遮住Filter的视图
    self.layerMaskSetting = [[UIView alloc] initWithFrame:self.settingsFrame.frame];
    [self.settingsFrame addSubview:self.layerMaskSetting];
    [self.layerMaskSetting setHidden:YES];
    [self.layerMaskSetting setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:NotiLocationChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings:) name:NotiShowSettings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:NotiBackToMain object:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 这里不能就用self.mainController来定，而是需要使用导航的顶层视图控制器来决定
    return self.mainNaviController.topViewController.supportedInterfaceOrientations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainEmbed"])
    {
        self.mainNaviController = [segue destinationViewController];
        self.mainController = (MainController *)[self.mainNaviController topViewController];
    }
    else if ([segue.identifier isEqualToString:@"settingEmbed"])
    {
        UINavigationController *nc = [segue destinationViewController];
        self.settingsController = (SettingsController *)[nc topViewController];
    }
}

- (void)viewDidLayoutSubviews
{
    self.settingsWidth.constant = self.view.frame.size.width - 64;
    CGRect frame = self.layerMaskMain.frame;
    [self.layerMaskMain setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kScreenHeight)];

    [super viewDidLayoutSubviews];
    [self.view layoutSubviews];
}

- (void)showSettings:(NSNotification *)notification
{
    self.settingsController.selectedLocationName = self.locationName;

    [self.settingsFrame setHidden:NO];      // 显示过滤层
    [self.layerMaskSetting setHidden:NO];   // 遮住过滤层
    CGRect frame = self.mainFrame.frame;
    frame.origin.x = self.view.frame.size.width - 64.0f;
    self.mainContainerX.constant = frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        self.mainFrame.frame = frame;
    } completion:^(BOOL finished) {
        [self.layerMaskMain setHidden:NO];      // 遮挡主层
        [self.layerMaskSetting setHidden:YES];  // 不再遮挡过滤层
    }];
}

- (void)backToMain:(NSNotification *)notification
{
    [self.layerMaskMain setHidden:NO];       // 遮挡主层
    
    CGRect frame = self.mainFrame.frame;
    frame.origin.x = 0;
    self.mainContainerX.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.mainFrame.frame = frame;
    } completion:^(BOOL finished) {
        [self.layerMaskMain setHidden:YES]; // 不再遮挡主层
        [self.settingsFrame setHidden:YES];  // 隐藏过滤层
    }];
}

- (void)locationChanged:(NSNotification *)notification
{
    if (notification.object != nil && [notification.object isKindOfClass:[NSString class]])
        self.locationName = (NSString *)notification.object;
}

- (void)setLocationName:(NSString *)locationName
{
    if ([_locationName isEqualToString:locationName])
        return;
    _locationName = locationName;
    self.mainController.navigationItem.title = self.locationName;
}

// 处理在显示Settings层时，前景视图上的滑动手势
- (void)handleGesture:(UIGestureRecognizer *)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:self];
    else if ([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        switch (pan.state)
        {
            case UIGestureRecognizerStateBegan:
                self.lastPoint = [pan translationInView:self.view];
                break;
                
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [pan translationInView:self.view];
                CGFloat offset = point.x - self.lastPoint.x;
                self.lastPoint = point;
                CGRect frame = self.mainFrame.frame;
                frame.origin.x += offset;
                frame.origin.x = frame.origin.x > (frame.size.width - 64.0f) ? (frame.size.width - 64.0f) : frame.origin.x;
                frame.origin.x = frame.origin.x < 0 ? 0 : frame.origin.x;
                self.mainFrame.frame = frame;
            }
                break;
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                CGRect frame = self.mainFrame.frame;
                if (self.lastPoint.x < -frame.size.width / 2)
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiBackToMain object:self];
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
