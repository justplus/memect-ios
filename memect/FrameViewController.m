//
//  FrameViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "FrameViewController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"

@interface FrameViewController ()

@end

@implementation FrameViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UINavigationController *home = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home"] tag:0];
        home.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
        
        
        DiscoverViewController *discover = [[DiscoverViewController alloc] init];
        discover.title = @"发现";
        discover.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] tag:1];
        discover.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
        
        MessageViewController *message = [[MessageViewController alloc] init];
        message.title = @"消息";
        message.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] tag:2];
        message.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
        
        MineViewController *mine = [[MineViewController alloc] init];
        mine.title = @"我的";
        mine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tabbar_profile"] tag:1];
        mine.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
        
        self.viewControllers = @[home, discover, message, mine];
    }
    return self;
}

@end
