//
//  MainController.m
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "MainController.h"

@interface MainController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollBackground;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIImageView *worldImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageWidth;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation MainController

// 初始化：设置默认页以及给Label加事件等等
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resizeScrollView:CGSizeMake(kScreenWidth, kScreenHeight)];

    UITapGestureRecognizer *tapReservation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcReservation addGestureRecognizer:tapReservation];
    UITapGestureRecognizer *tapNavigation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcNavigation addGestureRecognizer:tapNavigation];
    UITapGestureRecognizer *tapService = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcService addGestureRecognizer:tapService];

    _currentPage = NSNotFound;
    self.currentPage = 0;
}

// 内存警告检查
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 尺寸变化（包括旋转屏幕在内）触发操作
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self resizeScrollView:size];
}

// 重布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // 对竖屏时的滚动偏移进行复原
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        [self scrollToPage:self.currentPage];
    }
}

// 支持旋转屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Fucntions

// 视图尺寸变化后的重新布局
- (void)resizeScrollView:(CGSize)size
{
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        self.worldImageWidth.constant = size.width * 3;
        self.worldImageHeight.constant = size.height - 64;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.bottomView setHidden:NO];
    }
    else
    {
        self.worldImageWidth.constant = size.width;
        self.worldImageHeight.constant = size.height;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.bottomView setHidden:YES];
    }
}

// 设置页码，该属性设置将会同时对标签和滚动视图同时进行处理
- (void)setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage != currentPage)
    {
        _currentPage = currentPage;
        [self switchToButton:currentPage];
        [self scrollToPage:currentPage];
    }
}

// 切换滚动到视图的位置
- (void)scrollToPage:(NSInteger)index
{
    CGRect rect = CGRectMake(kScreenWidth * index, 0, kScreenWidth, self.scrollBackground.frame.size.height);
    [self.scrollBackground scrollRectToVisible:rect animated:YES];
}

// 切换文字动画。由于该过程中会重新定义文字大小，会触发Layout事件
- (void)switchToButton:(NSInteger)index
{
    [self.funcReservation setTextColor:[UIColor darkGrayColor]];
    [self.funcNavigation setTextColor:[UIColor darkGrayColor]];
    [self.funcService setTextColor:[UIColor darkGrayColor]];
    
    switch (index)
    {
        case 0:
            [self.funcReservation setTextColor:[UIColor blackColor]];
            [self.funcReservation setFont:[UIFont systemFontOfSize:20.0f]];
            [self.funcNavigation setFont:[UIFont systemFontOfSize:17.0f]];
            [self.funcService setFont:[UIFont systemFontOfSize:17.0f]];
            break;
        case 1:
            [self.funcNavigation setTextColor:[UIColor blackColor]];
            [self.funcReservation setFont:[UIFont systemFontOfSize:17.0f]];
            [self.funcNavigation setFont:[UIFont systemFontOfSize:20.0f]];
            [self.funcService setFont:[UIFont systemFontOfSize:17.0f]];
            break;
        case 2:
            [self.funcService setTextColor:[UIColor blackColor]];
            [self.funcReservation setFont:[UIFont systemFontOfSize:17.0f]];
            [self.funcNavigation setFont:[UIFont systemFontOfSize:17.0f]];
            [self.funcService setFont:[UIFont systemFontOfSize:20.0f]];
            break;
    }
}

#pragma mark - UIScrollView delegate

// 操作触发：滚动结束的时候进行切换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        self.currentPage = (int)(scrollView.contentOffset.x / kScreenWidth);
    }
}

// 操作触发：点击按钮后进行切换
- (void)funcPressed:(UIGestureRecognizer *)sender
{
    self.currentPage = sender.view.tag;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
