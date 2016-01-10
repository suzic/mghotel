//
//  POIViewController.m
//  mghotel
//
//  Created by 苏智 on 16/1/10.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "POIViewController.h"

@interface POIViewController ()

@property (strong, nonatomic) IBOutlet UIView *categoryService;
@property (strong, nonatomic) IBOutlet UIView *categoryShop;
@property (strong, nonatomic) IBOutlet UIView *categoryRestaurant;

@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation POIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 对分类标签进行圆角修饰
    self.categoryService.layer.cornerRadius = 6.0f;
    self.categoryShop.layer.cornerRadius = 6.0f;
    self.categoryRestaurant.layer.cornerRadius = 6.0f;
    
    // 对表格进行尾部渐变消隐处理
    self.gradientLayer = [CAGradientLayer layer];
    [self.gradientView.layer addSublayer:self.gradientLayer];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                                  (__bridge id)[UIColor whiteColor].CGColor];
    self.gradientLayer.locations = @[@(0.0f) ,@(0.8f)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 适配iPad：必须在这里对覆盖层定义layout后的尺寸
    self.gradientLayer.frame = self.gradientView.bounds;
}

// 支持旋转屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - UITableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"POIRow"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 适配iPad：必须在这里代码指定单元格背景为清除色
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
