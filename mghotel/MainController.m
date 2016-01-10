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
    
    // 计算滚动视图
    [self resizeScrollView:CGSizeMake(kScreenWidth, kScreenHeight)];
    
    // 图层调整
    [self.view bringSubviewToFront:self.funcNavigationView];
    [self.view bringSubviewToFront:self.bottomView];

    // 对底部栏进行操作事件注册
    UITapGestureRecognizer *tapReservation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcReservation addGestureRecognizer:tapReservation];
    UITapGestureRecognizer *tapNavigation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcNavigation addGestureRecognizer:tapNavigation];
    UITapGestureRecognizer *tapService = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcService addGestureRecognizer:tapService];
    
    // 对滚动视图增加一个点击手势
    UITapGestureRecognizer *tapScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    [self.scrollBackground addGestureRecognizer:tapScreen];
    UITapGestureRecognizer *tapList = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    [self.funcNavigationView addGestureRecognizer:tapList];
    
    // 添加滚动视图功能层
    self.funcReservationView = [FuncReservationView setupReservationView];
    [self.scrollBackground addSubview:self.funcReservationView];
    self.funcServicenView = [FuncServiceView setupServiceView];
    [self.scrollBackground addSubview:self.funcServicenView];

    // 设置页面索引在变动的时候会执行一次初始化，故特意先设置NSNotFound值以后再置为0
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
    
    // UIDevice的设备orientation的问题：对于设备而言，除了横竖屏之外还有屏幕朝上还是朝下的判断。而这里我们只要横竖屏判断。
    // 因此不要用这个 [[UIDevice currentDevice] orientation]
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        // 对竖屏时的滚动偏移进行复原
        [self scrollToPage:self.currentPage];
        
        [self.funcReservationView setFrame:CGRectMake(0, 0, kScreenWidth, self.scrollBackground.frame.size.height)];
        [self.funcServicenView setFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.scrollBackground.frame.size.height)];
        self.showFunctionLayer = YES;
    }
    else
    {
        self.showFunctionLayer = NO;
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
    else if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        self.worldImageWidth.constant = size.width;
        self.worldImageHeight.constant = size.height;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.bottomView setHidden:YES];
    }
    // else 再有其他的变化是非横竖屏的旋转，一般是正反屏的状态，忽略
    // 这里不用UIInterfaceOrientation
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
    
    self.showFunctionLayer = NO;
    
    switch (index)
    {
        case 0:
            [self.funcReservation setTextColor:[UIColor blackColor]];
            [self.funcReservation setFont:[UIFont systemFontOfSize:20.0f]];
            [self.funcNavigation setFont:[UIFont systemFontOfSize:15.0f]];
            [self.funcService setFont:[UIFont systemFontOfSize:15.0f]];
            break;
        case 1:
            [self.funcNavigation setTextColor:[UIColor blackColor]];
            [self.funcReservation setFont:[UIFont systemFontOfSize:15.0f]];
            [self.funcNavigation setFont:[UIFont systemFontOfSize:20.0f]];
            [self.funcService setFont:[UIFont systemFontOfSize:15.0f]];
            break;
        case 2:
            [self.funcService setTextColor:[UIColor blackColor]];
            [self.funcReservation setFont:[UIFont systemFontOfSize:15.0f]];
            [self.funcNavigation setFont:[UIFont systemFontOfSize:15.0f]];
            [self.funcService setFont:[UIFont systemFontOfSize:20.0f]];
            break;
    }
}

// 对前景功能层显示隐藏的控制
- (void)setShowFunctionLayer:(BOOL)showFunctionLayer
{
    if (_showFunctionLayer == showFunctionLayer)
        return;
    
    _showFunctionLayer = showFunctionLayer;
    if (_showFunctionLayer)
    {
        self.funcReservationView.hidden = NO;
        self.funcNavigationView.hidden = self.currentPage == 1 ? NO : YES;
        self.funcServicenView.hidden = NO;
        self.funcReservationView.alpha = 0;
        self.funcNavigationView.alpha = 0;
        self.funcServicenView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.funcReservationView.alpha = 1;
            self.funcNavigationView.alpha = self.currentPage == 1 ? 1 : 0;
            self.funcServicenView.alpha = 1;
        }];
    }
    else
    {
        self.funcReservationView.alpha = 1;
        self.funcNavigationView.alpha = self.currentPage == 1 ? 1 : 0;;
        self.funcServicenView.alpha = 1;
        [UIView animateWithDuration:0.5 animations:^{
            self.funcReservationView.alpha = 0;
            self.funcNavigationView.alpha = 0;
            self.funcServicenView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished == YES)
            {
                self.funcReservationView.hidden = YES;
                self.funcNavigationView.hidden = YES;
                self.funcServicenView.hidden = YES;
            }
        }];
    }
}

#pragma mark - UIScrollView delegate

// 操作触发：滚动结束的时候进行切换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // UIDevice的设备orientation的问题：对于设备而言，除了横竖屏之外还有屏幕朝上还是朝下的判断。而这里我们只要横竖屏判断。
    // 因此不要用这个 [[UIDevice currentDevice] orientation]
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        self.currentPage = (int)(scrollView.contentOffset.x / kScreenWidth);
        self.showFunctionLayer = YES;
    }
}

// 操作触发：滚动开始的时候隐藏前景功能
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.showFunctionLayer = NO;
}

// 操作触发：点击按钮后进行切换
- (void)funcPressed:(UIGestureRecognizer *)sender
{
    self.currentPage = sender.view.tag;
}

// 屏幕单点
- (void)screenTapped:(UIGestureRecognizer *)sender
{
    self.showFunctionLayer = !self.showFunctionLayer;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
