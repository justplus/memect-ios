//
//  HomeViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "HomeViewController.h"
#import "Account.h"
#import "MERequestTool.h"
#import "NSDictionary+Json.h"
#import "MemectThread.h"
#import "ThreadCell.h"
#include "NSDictionary_JSONExtensions.h"

#define MEMECT_URL      @"http://memect.sinaapp.com/api"

@interface HomeViewController ()
{
    NSMutableArray *_cellArray;
    NSMutableArray *_dataArray;
}
@end

@implementation HomeViewController

#pragma mark - init UI
- (void)loadView
{
    [self setupView];
    [self setupDataSource];
}

// 初始化布局
- (void)setupView {
    self.tableView = [UITableView new];
    self.navigationItem.title = @"首页";
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

// 初始化数据源
- (void)setupDataSource {
    Account *account = [[Account alloc] initWithArchiever];
    NSString *memect_list_url = [NSString stringWithFormat:@"%@/user/%lld/category/%d/page/%d", MEMECT_URL, account.uid, 0, 1];
    [MERequestTool GET:memect_list_url parameters:nil response:@"json" success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = (NSDictionary *)responseObject;
            int status = [result intValueForKey:@"status"];
            if (status == 1) {
                NSDictionary *data = [result dictionaryValueForKey:@"data"];
                // int total = [data intValueForKey:@"total"];
                // 填充数据到数据源
                _cellArray = [[NSMutableArray alloc] init];
                _dataArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in [data arrayValueForKey:@"threads"]) {
                    MemectThread *thread = [[MemectThread alloc] initWithDictionary:dict];
                    [_dataArray addObject:thread];
                    ThreadCell *cell = [[ThreadCell alloc] init];
                    [_cellArray addObject:cell];
                }
                [self.tableView reloadData];
            }
            else {
                NSLog(@"request memect error");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"request memect error:%@", error);
    }];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadCell"];
    if (!cell) {
        cell = [[ThreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"threadCell"];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.thread = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadCell *cell = [_cellArray objectAtIndex:indexPath.row];
    cell.thread = [_dataArray objectAtIndex:indexPath.row];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
