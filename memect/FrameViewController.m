//
//  FrameViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/28.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "FrameViewController.h"
#import "MMDrawerController.h"
#import "HomeViewController.h"
#import "SideMenuViewController.h"

@interface FrameViewController ()

@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation FrameViewController

- (void)viewDidLoad {
    UIViewController * leftSideDrawerViewController = [[SideMenuViewController alloc] init];
    UIViewController * centerViewController = [[HomeViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [navigationController setRestorationIdentifier:@"MECenterNavigationControllerRestorationKey"];
    UINavigationController * leftSideNavController = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MELeftNavigationControllerRestorationKey"];
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setMaximumLeftDrawerWidth:200.0f];
    [self.drawerController setRestorationIdentifier:@"MEDrawer"];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setShouldStretchDrawer:NO];
    [self.view addSubview:self.drawerController.view];
}

@end
