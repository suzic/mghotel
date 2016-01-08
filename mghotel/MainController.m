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

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)functionPress:(id)sender
{
    UIBarButtonItem* functionButton = (UIBarButtonItem *)sender;
    NSInteger index = functionButton.tag;
    [self switchToButton:index];
    [self scrollToPage:index];
}

- (void)scrollToPage:(NSInteger)index
{
    CGRect rect = CGRectMake(kScreenWidth * index, 0, kScreenWidth, self.scrollBackground.frame.size.height);
    [self.scrollBackground scrollRectToVisible:rect animated:YES];
}

- (void)switchToButton:(NSInteger)index
{
    [self.funcReservation setTintColor:[UIColor grayColor]];
    [self.funcNavigation setTintColor:[UIColor grayColor]];
    [self.funcCall setTintColor:[UIColor grayColor]];
    
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
    NSInteger page = (int)(scrollView.contentOffset.x / kScreenWidth);
    [self switchToButton:page];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
