//
//  MapServiceController.m
//  mghotel
//
//  Created by 苏智 on 16/1/11.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MapServiceController.h"

@interface MapServiceController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *centerStartPoint;

@property (strong, nonatomic) IBOutlet UIView *functionPanel;
@property (strong, nonatomic) IBOutlet UIScrollView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *mapImage;

@property (strong, nonatomic) IBOutlet UIView *regionStart;
@property (strong, nonatomic) IBOutlet UIView *regionEnd;
@property (strong, nonatomic) IBOutlet UIView *regionRequire;
@property (strong, nonatomic) IBOutlet UIView *regionConfirm;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *functionPanelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *regionRequireTop;
@property (strong, nonatomic) IBOutlet UIButton *startText;
@property (strong, nonatomic) IBOutlet UIButton *endText;
@property (strong, nonatomic) IBOutlet UIButton *needText;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UILabel *submitPrompt;

@end

@implementation MapServiceController
{
    BOOL showConfirm;
    int demoIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showConfirm = NO;
    demoIndex = 0;
    
    self.submitButton.layer.cornerRadius = 4.0f;
    self.centerStartPoint.layer.cornerRadius = 24.0f;
    self.functionPanel.layer.cornerRadius = 4.0f;
    self.regionStart.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.regionStart.layer.borderWidth = 0.5f;
    self.regionConfirm.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.regionConfirm.layer.borderWidth = 0.5f;
    
    [self layoutFunctionPanelWithConfirmRow:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect rect = CGRectMake((self.mapImage.frame.size.width - self.mapView.frame.size.width) / 2,
                             (self.mapImage.frame.size.height - self.mapView.frame.size.height) / 2,
                             self.mapView.frame.size.width, self.mapView.frame.size.height);
    [self.mapView scrollRectToVisible:rect animated:NO];
}

- (void)layoutFunctionPanelWithConfirmRow:(BOOL)confirm
{
    if (self.functionMode.selectedSegmentIndex == 0)
    {
        self.functionPanelHeight.constant = 45 * 2 - 2 + (confirm ? 88 : 0);
        self.regionEnd.hidden = NO;
        self.regionRequire.hidden = YES;
        self.regionRequireTop.constant = 45;
        self.regionConfirm.hidden = !confirm;
        [self.startText setTitle:@"(设置您的起点)" forState:UIControlStateNormal];
    }
    else
    {
        self.functionPanelHeight.constant = 45 * 2 - 2 + (confirm ? 88 : 0);
        self.regionEnd.hidden = YES;
        self.regionRequire.hidden = NO;
        self.regionRequireTop.constant = 0;
        self.regionConfirm.hidden = !confirm;
        [self.startText setTitle:@"(设置您的位置)" forState:UIControlStateNormal];
    }
}

- (IBAction)returnHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)functionModeChanged:(id)sender
{
    [self layoutFunctionPanelWithConfirmRow:NO];
}

- (IBAction)startChanging:(id)sender
{
    // 正确的做法是这里不应当处理任何事件。但为演示，现在点击这里模拟位置变化
    demoIndex = (++demoIndex) % 3;
    switch (demoIndex)
    {
        case 0:
            [self layoutFunctionPanelWithConfirmRow:showConfirm];
            break;
        case 1:
            [self.startText setTitle:@"嗨翻水乐园" forState:UIControlStateNormal];
            break;
        case 2:
            [self.startText setTitle:@"面莊会" forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)chooseTarget:(id)sender
{
    // 选择终点方法。正确的做法是这里发生导航进入搜索页面。但为演示，现在点击这里直接出结果
    showConfirm = !showConfirm;
    [self layoutFunctionPanelWithConfirmRow:showConfirm];
    
    if (showConfirm)
    {
        [self.endText setTitle:@"一景海鲜坊" forState:UIControlStateNormal];
        [self.submitPrompt setText:@"步行约500米，大约需要5分钟。"];
    }
    else
        [self.endText setTitle:@"(设置您的目的地)" forState:UIControlStateNormal];
}

- (IBAction)chooseRequire:(id)sender
{
    // 选择需求的方法。正确的做法是这里发生导航进入服务选择。但为演示，现在点击这里直接出结果
    showConfirm = !showConfirm;
    [self layoutFunctionPanelWithConfirmRow:showConfirm];
    if (showConfirm)
    {
        [self.needText setTitle:@"我需要 一杯红酒" forState:UIControlStateNormal];
        [self.submitPrompt setText:@"需消费58元。请您原地等候服务员。"];
    }
    else
        [self.needText setTitle:@"我需要……" forState:UIControlStateNormal];
}

#pragma mark - UIScrollView delegate

@end
