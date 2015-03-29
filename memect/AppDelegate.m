//
//  AppDelegate.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "AppDelegate.h"
#import "Account.h"
#import "User.h"
#import "MemectType.h"
#import "LoginViewController.h"
#import "FrameViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    //判断是否进行过授权
    Account *account = [[Account alloc] initWithArchiever];
    User *user = [[User alloc] initWithDictionary:account.userInfo];
    if (user && [[NSDate date] compare:account.expiresTime]) {
        // 即便已经缓存了数据, 但是仍然要同步数据，因为数据可能会在其他地方发生变化
        [MERequestTool GET:GET_USER_URL parameters:@{@"access_token": account.accessToken, @"uid": @(account.uid)} response:@"json" success:^(id responseObject) {
            account.userInfo = responseObject;
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            if(data){
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSMutableDictionary *userSaveParameters = [NSMutableDictionary dictionary];
                userSaveParameters[@"weibo_uid"] = @(account.uid);
                userSaveParameters[@"user_info"] = jsonString;
                [MERequestTool POST:SAVE_USER_URL parameters:userSaveParameters response:@"json" success:^(id responseObject) {
                    if([responseObject intValueForKey:@"status"] == 1) {
                        //[account saveAccount];
                        // 获取用户订阅列表并缓存
                        NSString *getMemectTypeUrl = [NSString stringWithFormat:@"%@%lld", GET_MEMECT_LIST, account.uid];
                        [MERequestTool GET:getMemectTypeUrl parameters:nil response:@"json" success:^(id responseObject) {
                            NSDictionary *result = (NSDictionary *)responseObject;
                            int status = [result intValueForKey:@"status"];
                            if (status == 1) {
                                NSDictionary *data = [result dictionaryValueForKey:@"data"];
                                //int total = [data intValueForKey:@"total"];
                                NSMutableArray *types = [[NSMutableArray alloc] init];
                                for (NSDictionary *dict in [data arrayValueForKey:@"types"]) {
                                    [types addObject:[[MemectType alloc] initWithDictionary:dict]];
                                }
                                account.memectTypes = [types copy];
                                [account saveAccount];
                            }
                        } failure:^(NSError *error) {
                            NSLog(@"getMememType Error:%@", error);
                        }];
                    }
                    else {
                        NSLog(@"saveUserToDB Error");
                    }
                } failure:^(NSError *error) {
                    NSLog(@"saveUser Error: %@", error);
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"getUser Error:%@", error);
        }];
        
        
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
        self.window.rootViewController = [[FrameViewController alloc] init];
    }
    else{
        self.window.rootViewController = [[LoginViewController alloc] init];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
