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
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UIView *switchView;
@property (strong, nonatomic) IBOutlet UIImageView *worldImage;
@property (strong, nonatomic) IBOutlet UIView *worldLayer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *funcNavigationFront;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *funcNavigationWidth;

@property (assign, nonatomic) NSInteger currentPage;    // 当前水平索引位置
@property (assign, nonatomic) BOOL showFunctionLayer;   // 控制显示功能层。该属性提供了一种切换显示的淡入淡出效果，但受layerMode影响
@property (assign, nonatomic) BOOL layerMode;           // 是否处于功能层显示模式。如果该属性为NO，showFunctionLayer属性无效
@property (assign, nonatomic) BOOL inPortraitMode;      // 是否处于竖屏显示模式。非竖屏显示模式将强制layerMode为NO

@property (assign, nonatomic) BOOL disableRotate;

@end

@implementation MainController

// 初始化：设置默认页以及给Label加事件等等
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.disableRotate = NO;

    // 附加UI的设置
    self.titleView.layer.cornerRadius = 4.0f;
    self.switchView.layer.cornerRadius = 4.0f;
    self.switchView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.switchView.layer.borderWidth = 0.5f;
    self.filterService.layer.cornerRadius = 4.0f;
    self.filterShop.layer.cornerRadius = 4.0f;
    self.filterFood.layer.cornerRadius = 4.0f;
    
    // 计算滚动视图
    [self resizeScrollView:CGSizeMake(kScreenWidth, kScreenHeight)];

    // 对底部栏进行操作事件注册
    UITapGestureRecognizer *tapReservation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcReservation addGestureRecognizer:tapReservation];
    UITapGestureRecognizer *tapNavigation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcNavigation addGestureRecognizer:tapNavigation];
    UITapGestureRecognizer *tapService = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcPressed:)];
    [self.funcService addGestureRecognizer:tapService];

    // 添加滚动视图功能层
    self.funcReservationView = [FuncReservationView setupReservationView];
    [self.scrollBackground addSubview:self.funcReservationView];
    self.funcServicenView = [FuncServiceView setupServiceView];
    [self.scrollBackground addSubview:self.funcServicenView];
    [self.scrollBackground bringSubviewToFront:self.funcNavigationView];

    // 设置页面索引在变动的时候会执行一次初始化，故特意先设置NSNotFound值以后再置为0
    _currentPage = NSNotFound;
    self.inPortraitMode = YES;
    self.layerMode = YES;
    self.currentPage = 0;
    
    [self setupWorldLayer];

    // 该层面上的消息接收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain:) name:NotiBackToMain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMap:) name:NotiShowMap object:nil];
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
    // UIDevice的设备orientation的问题：对于设备而言，除了横竖屏之外还有屏幕朝上还是朝下的判断。而这里我们只要横竖屏判断。
    // 因此不要用这个 [[UIDevice currentDevice] orientation]
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        // 对竖屏时的滚动偏移进行复原
        [self scrollToPage:self.currentPage];
        
        [self.funcReservationView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.funcServicenView setFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight)];
        self.funcNavigationFront.constant = kScreenWidth;
        self.funcNavigationWidth.constant = kScreenWidth;

        self.inPortraitMode = YES;
        self.showFunctionLayer = YES;
    }
    else
    {
        self.inPortraitMode = NO;
        self.showFunctionLayer = NO;
    }
    
    [self resizeWorldLayer];

    [super viewDidLayoutSubviews];
    [self.view layoutSubviews];
}

// 支持旋转屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.disableRotate == YES ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskAll;
}

- (void)backToMain:(NSNotification *)notification
{
    self.disableRotate = NO;
}

- (void)showMap:(NSNotification *)notification
{
    self.layerMode = NO;
}

#pragma mark - Fucntions

- (void)setupWorldLayer
{
    for (int index = 0; index < 13; index++)
    {
        CGRect focusFrame = CGRectMake(0, 0, self.worldLayer.frame.size.width, self.worldLayer.frame.size.height);
        UIImageView *oneFocus = [[UIImageView alloc] initWithFrame:focusFrame];
        NSString *imageName = [NSString stringWithFormat:@"wl_%d", index];
        oneFocus.image = [UIImage imageNamed:imageName];
        oneFocus.contentMode = UIViewContentModeScaleAspectFit;
        [self.worldLayer addSubview:oneFocus];
        oneFocus.hidden = YES;
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

// 视图尺寸变化后的重新布局
- (void)resizeScrollView:(CGSize)size
{
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        self.worldImageTop.constant = 60;
        self.worldImageBottom.constant = 40;
        self.worldImageWidth.constant = size.width * 3;
        self.worldImageHeight.constant = size.height - 100;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.bottomView setHidden:NO];
    }
    else if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        self.worldImageTop.constant = 0;
        self.worldImageBottom.constant = 0;
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
    if (index == NSNotFound)
        return;
    
    [self.funcReservation setTextColor:[UIColor darkGrayColor]];
    [self.funcNavigation setTextColor:[UIColor darkGrayColor]];
    [self.funcService setTextColor:[UIColor darkGrayColor]];
    
    [self.funcReservation setFont:[UIFont systemFontOfSize:15.0f]];
    [self.funcNavigation setFont:[UIFont systemFontOfSize:15.0f]];
    [self.funcService setFont:[UIFont systemFontOfSize:15.0f]];

    self.showFunctionLayer = NO;
    
    if (_layerMode)
    {
        switch (index)
        {
            case 0:
                [self.funcReservation setTextColor:[UIColor blackColor]];
                [self.funcReservation setFont:[UIFont systemFontOfSize:20.0f]];
                break;
            case 1:
                [self.funcNavigation setTextColor:[UIColor blackColor]];
                [self.funcNavigation setFont:[UIFont systemFontOfSize:20.0f]];
                break;
            case 2:
                [self.funcService setTextColor:[UIColor blackColor]];
                [self.funcService setFont:[UIFont systemFontOfSize:20.0f]];
                break;
        }
    }
}

// 对前景功能层显示隐藏的控制
- (void)setShowFunctionLayer:(BOOL)showFunctionLayer
{
    // 显示动画会收到layerMode的限制
    if (_layerMode == NO)
        showFunctionLayer = NO;

    if (_showFunctionLayer == showFunctionLayer)
        return;
    
    _showFunctionLayer = showFunctionLayer;
    if (_showFunctionLayer)
    {
        self.funcReservationView.hidden = NO;
        self.funcNavigationView.hidden = NO;
        self.funcServicenView.hidden = NO;
        self.funcReservationView.alpha = 0;
        self.funcNavigationView.alpha = 0;
        self.funcServicenView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.funcReservationView.alpha = 1;
            self.funcNavigationView.alpha = 1;
            self.funcServicenView.alpha = 1;
        }];
    }
    else
    {
        self.funcReservationView.alpha = 1;
        self.funcNavigationView.alpha = 1;
        self.funcServicenView.alpha = 1;
        [UIView animateWithDuration:0.5 animations:^{
            self.funcReservationView.alpha = 0;
            self.funcNavigationView.alpha = 0;
            self.funcServicenView.alpha = 0;
        } completion:^(BOOL finished) {
            // 补充：由于可能连续多次调用显隐效果，动画最后可能显隐又发生改变。此处要确保layerMode下最终不会隐藏前景功能涂层。
            if (finished == YES && !_layerMode)
            {
                self.funcReservationView.hidden = YES;
                self.funcNavigationView.hidden = YES;
                self.funcServicenView.hidden = YES;
            }
        }];
    }
}

// 前景层模式定义
- (void)setLayerMode:(BOOL)layerMode
{
    // 前景层模式会受到横竖屏的限制
    if (_inPortraitMode == NO)
        layerMode = NO;
    self.switchView.hidden = layerMode || !_inPortraitMode;
    
    if (_layerMode == layerMode)
        return;
    
    _layerMode = layerMode;
    self.worldLayer.hidden = layerMode;
    self.sideView.hidden = layerMode;
    self.titleView.hidden = layerMode;
    self.scrollBackground.pagingEnabled = layerMode;
    
    [self.navigationController setNavigationBarHidden:!layerMode animated:YES];
    // 前景层模式切换时，showFunctionLayer动画跟随执行
    self.showFunctionLayer = layerMode;
    // 前景层模式切换会影响到底部按钮的缩放效果
    [self switchToButton:self.currentPage];
}

// 横竖屏的模式属性变化
- (void)setInPortraitMode:(BOOL)inPortraitMode
{
    if (_inPortraitMode == inPortraitMode)
        return;
    _inPortraitMode = inPortraitMode;
    self.switchView.hidden = _layerMode || !_inPortraitMode;
    [self.navigationController setNavigationBarHidden:!_layerMode animated:YES];

    if (inPortraitMode == NO)
        self.layerMode = NO;
}

#pragma mark - UIScrollView delegate

// 操作触发：滚动结束的时候进行切换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_layerMode == NO)
        return;
    
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
    // 选择相同的标签视同切换层显示模式
    if (self.currentPage == sender.view.tag)
    {
        self.layerMode = !self.layerMode;
    }
    // 选择不同的标签视同一定进入显示功能层模式
    else
    {
        self.layerMode = YES;
        self.currentPage = sender.view.tag;
    }
}

// 进入用户中心设置
- (IBAction)showSettings:(id)sender
{
    self.disableRotate = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiShowSettings object:sender];
}

// 点击工具栏按钮
- (IBAction)switchBackground:(id)sender
{
    self.layerMode = !self.layerMode;
}

// 屏幕单点
- (void)focusTarget:(UIGestureRecognizer *)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint pt = [tap locationInView:self.worldLayer];
    
    for (UIImageView* imageView in self.worldLayer.subviews)
    {
        imageView.hidden = NO;
        if (![self point:pt insideImageView:imageView])
            imageView.hidden = YES;
    }
}

- (BOOL)point:(CGPoint)point insideImageView:(UIImageView *)imageView
{
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 1, NULL, kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [imageView.layer renderInContext:context];
    UIGraphicsPopContext();
    CGContextRelease(context);

    CGFloat alpha = pixel[0] / 255.0f;
    BOOL transparent = alpha < 0.1f;
    return !transparent;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMap"])
    {
    }
}

@end
