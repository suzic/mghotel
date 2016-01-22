//
//  SearchPOIController.m
//  mghotel
//
//  Created by 苏智 on 16/1/11.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "SearchPOIController.h"

@interface SearchPOIController () <UISearchBarDelegate>

@property (retain, nonatomic) NSMutableArray *resultList;

@end

@implementation SearchPOIController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSearchResult:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (NSMutableArray *)resultList
{
    if (_resultList == nil)
        _resultList = [NSMutableArray arrayWithCapacity:10];
    return _resultList;
}

- (void)setupSearchResult:(NSInteger)resultCount
{
    [self.resultList removeAllObjects];
    if (resultCount > 0) [self.resultList addObject:@"一景海鲜坊"];
    if (resultCount > 1) [self.resultList addObject:@"红树林海鲜广场"];
    if (resultCount > 2) [self.resultList addObject:@"海南沿江饭店"];
    if (resultCount > 3) [self.resultList addObject:@"水乐园海盗船"];
    if (resultCount > 4) [self.resultList addObject:@"海景房"];
    [self.tableView reloadData];
}

#pragma mark- UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSInteger demoCount = 0;
    switch (searchText.length)
    {
        case 0:
            demoCount = 0;
            break;
        case 1:
            demoCount = 5;
            break;
        case 2:
            demoCount = 2;
            break;
        case 3:
            demoCount = 1;
            break;
        default:
            demoCount = 0;
            break;
    }
    [self setupSearchResult:demoCount];
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultRow"];
    cell.textLabel.text = self.resultList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
