//
//  SettingsController.m
//  mghotel
//
//  Created by 苏智 on 16/1/8.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "SettingsController.h"
#import "LocationCell.h"
#import "SettingCell.h"

@interface SettingsController ()

@property (retain, nonatomic) LocationCell *lastCell;

@end

@implementation SettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedLocationName:(NSString *)selectedLocationName
{
    if ([_selectedLocationName isEqualToString:selectedLocationName])
        return;
    _selectedLocationName = selectedLocationName;
    [self.settingTable reloadData];
}

#pragma mark - UITableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Section for User, World, Settings
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 3;

        case 1:
            return 4;
            
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            switch (indexPath.row)
            {
                case 0:
                    cell.settingName.text = @"用户信息";
                    break;
                case 1:
                    cell.settingName.text = @"我的卡券";
                    break;
                case 2:
                    cell.settingName.text = @"消息中心";
                    break;
            }
            return cell;
        }
            
        case 1:
        {
            LocationCell* cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier:@"locationCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (indexPath.row)
            {
                case 0:
                    cell.locationName.text = @"三亚・三亚湾";
                    break;
                case 1:
                    cell.locationName.text = @"三亚・亚龙湾";
                    break;
                case 2:
                    cell.locationName.text = @"三亚・海棠湾";
                    break;
                case 3:
                    cell.locationName.text = @"青岛・灵山湾";
                    break;
            }
            if ([cell.locationName.text isEqualToString:self.selectedLocationName])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            return cell;
        }
            
        default:
        {
            SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            cell.settingName.text = @"设置";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        LocationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell != self.lastCell)
        {
            if (self.lastCell != nil)
                self.lastCell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.lastCell = cell;
            self.selectedLocationName = cell.locationName.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiLocationChanged object:self.selectedLocationName];
        }
    }
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
