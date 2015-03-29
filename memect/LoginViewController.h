//
//  LoginViewController.h
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MERequestTool.h"
#import "Account.h"
#import "User.h"
#import "NSDictionary+Json.h"
#import "Util.h"
#import "FrameViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define OAUTH_URL           @"https://api.weibo.com/oauth2/authorize"
#define APP_KEY             @"3865813480"
#define APP_SECRET          @"d6ead21a4c4196cfc7cf9e18fe41b5da"
#define REDIRECT_URL        @"http://memect.zhaoliang.info"
#define ACCESS_TOKEN_URL    @"https://api.weibo.com/oauth2/access_token"

#define GET_USER_URL        @"https://api.weibo.com/2/users/show.json"
#define SAVE_USER_URL       @"http://memect.sinaapp.com/api/user"
#define GET_MEMECT_LIST     @"http://memect.sinaapp.com/api/types/user/"

@interface LoginViewController : UIViewController

@end
