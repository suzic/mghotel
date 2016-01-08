//
//  SettingsController.h
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *settingTable;

@end
