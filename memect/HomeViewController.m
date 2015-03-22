//
//  HomeViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)loadView
{
    [self setupView];
}

//初始化布局
- (void)setupView
{
    self.tableView = [UITableView new];
    self.navigationItem.title = @"首页";
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
