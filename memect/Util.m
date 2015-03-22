//
//  Util.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "Util.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation Util

+ (void)showExceptionDialog:(NSString *)message view:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

@end
