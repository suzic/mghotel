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
@property (strong, nonatomic) IBOutlet UIImageView *worldImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *worldImageWidth;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPage = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        self.worldImageWidth.constant = kScreenWidth * 3;
        self.worldImageHeight.constant = self.scrollBackground.frame.size.height;
        self.scrollBackground.contentOffset = CGPointMake(kScreenWidth * self.currentPage, 0);
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else
    {
        self.worldImageWidth.constant = kScreenWidth;
        self.worldImageHeight.constant = self.scrollBackground.frame.size.height;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

#pragma mark - Fucntions

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self switchToButton:currentPage];
    [self scrollToPage:currentPage];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)functionPress:(id)sender
{
    UIBarButtonItem* functionButton = (UIBarButtonItem *)sender;
    self.currentPage = functionButton.tag;
}

- (void)scrollToPage:(NSInteger)index
{
    CGRect rect = CGRectMake(kScreenWidth * index, 0, kScreenWidth, self.scrollBackground.frame.size.height);
    [self.scrollBackground scrollRectToVisible:rect animated:YES];
}

- (void)switchToButton:(NSInteger)index
{
//    [self.funcReservation setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}
//                                        forState:UIControlStateSelected];
//    [self.funcReservation setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}
//                                        forState:UIControlStateDisabled];
//    [self.funcReservation setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}
//                                        forState:UIControlStateFocused];
//    [self.funcReservation setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
//                                        forState:UIControlStateNormal];
//    [self.funcReservation setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
//                                        forState:UIControlStateFocused];

    [self.funcReservation setTintColor:[UIColor lightGrayColor]];
    [self.funcNavigation setTintColor:[UIColor lightGrayColor]];
    [self.funcCall setTintColor:[UIColor lightGrayColor]];
    
    switch (index)
    {
        case 0:
            [self.funcReservation setTintColor:[UIColor blackColor]];
            break;
        case 1:
            [self.funcNavigation setTintColor:[UIColor blackColor]];
            break;
        case 2:
            [self.funcCall setTintColor:[UIColor blackColor]];
            break;
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        NSInteger page = (int)(scrollView.contentOffset.x / kScreenWidth);
        [self switchToButton:page];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
