//
//  UIApplication+NetworkActivity.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "UIApplication+NetworkActivity.h"

static NSInteger activityCount = 0;
@implementation UIApplication (NetworkActivity)

- (void)showNetworkActivityIndicator {
    if ([[UIApplication sharedApplication] isStatusBarHidden]) return;
    @synchronized ([UIApplication sharedApplication]) {
        if (activityCount == 0) {
            [self setNetworkActivityIndicatorVisible:YES];
        }
        activityCount++;
    }
}
- (void)hideNetworkActivityIndicator {
    if ([[UIApplication sharedApplication] isStatusBarHidden]) return;
    @synchronized ([UIApplication sharedApplication]) {
        activityCount--;
        if (activityCount <= 0) {
            [self setNetworkActivityIndicatorVisible:NO];
            activityCount=0;
        }
    }
}

@end
