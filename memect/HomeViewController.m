//
//  HomeViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "HomeViewController.h"
#import "Account.h"
#import "User.h"
#import "MERequestTool.h"
#import "NSDictionary+Json.h"
#import "MemectThread.h"
#import "ThreadCell.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

#define MEMECT_URL      @"http://memect.sinaapp.com/api"

@interface HomeViewController ()
{
    NSMutableArray *_cellArray;
    NSMutableArray *_dataArray;
    UIActivityIndicatorView *_loadingView;
    NSMutableDictionary *_cache;
}
@end

@implementation HomeViewController

#pragma mark - init UI
- (void)loadView
{
    [self setupView];
    [self setupData];
    [self setupDataSource:0 page:1];
}

// 初始化布局
- (void)setupView {
    self.tableView = [UITableView new];
    self.navigationItem.title = @"简报";
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // 设置导航条
    NSArray *segmentTitle = [[NSArray alloc]initWithObjects:@"今日焦点", @"最近动态", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTitle];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    // 设置导航条左边按钮
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftDrawerButton];
}

// 初始化变量
- (void)setupData {
    _cellArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    // 初始化缓存
    _cache = [NSMutableDictionary dictionary];
}

// 初始化数据源
- (void)setupDataSource:(int)category page:(int)page {
    
    // 设置加载指示器
    _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_loadingView setCenter:CGPointMake(UIScreen.mainScreen.applicationFrame.size.width/2, 16)];
    [_loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.tableView addSubview:_loadingView];
    [_loadingView startAnimating];
    
    Account *account = [[Account alloc] initWithArchiever];
    User *user = [[User alloc] initWithDictionary:account.userInfo];
    NSString *memect_list_url = [NSString stringWithFormat:@"%@/user/%lld/category/%d/page/%d", MEMECT_URL,
                                 user.id, category, page];
    [MERequestTool GET:memect_list_url parameters:nil response:@"json" success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [_loadingView stopAnimating];
            [_loadingView removeFromSuperview];
            NSDictionary *result = (NSDictionary *)responseObject;
            int status = [result intValueForKey:@"status"];
            if (status == 1) {
                NSDictionary *data = [result dictionaryValueForKey:@"data"];
                // int total = [data intValueForKey:@"total"];
                // 获取thread index
                int index = 1;
                NSString *lastDate = nil;
                for (NSDictionary *dict in [data arrayValueForKey:@"threads"]) {
                    MemectThread *thread = [[MemectThread alloc] initWithDictionary:dict];
                    if ([thread.createDate isEqualToString:lastDate]) {
                        index++;
                    }
                    else {
                        index = 1;
                    }
                    lastDate = thread.createDate;
                    thread.index = index;
                    [_dataArray addObject:thread];
                    ThreadCell *cell = [[ThreadCell alloc] init];
                    [_cellArray addObject:cell];
                    
                }
                // 缓存数据
                _cache[[NSString stringWithFormat:@"%d_data", category]] = _dataArray;
                //_cache[[NSString stringWithFormat:@"%d_cell", category]] = _cellArray;
                [self.tableView reloadData];
            }
            else {
                [_loadingView stopAnimating];
                [_loadingView removeFromSuperview];
                NSLog(@"request memect error");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"request memect error:%@", error);
    }];
}

#pragma mark - gc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 收到内存警告时，清除缓存
    _cache = nil;
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"taped");
}

#pragma mark - navigation bar action
- (void)segmentAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    int selectedIndex = (int)segmentedControl.selectedSegmentIndex;
    // 清空cell
    _dataArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    if (![_cache objectForKey:[NSString stringWithFormat:@"%d_data", selectedIndex]]) {
        [self setupDataSource:selectedIndex page:1];
    }
    else {
        _dataArray = [_cache objectForKey:[NSString stringWithFormat:@"%d_data", selectedIndex]];
        //_cellArray = [_cache objectForKey:[NSString stringWithFormat:@"%d_cell", selectedIndex]];
        [self.tableView reloadData];
    }
}
@end
