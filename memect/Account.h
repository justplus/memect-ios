//
//  Account.h
//  kongku
//
//  Created by zhaoliang on 15/3/7.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>
//access_token
@property(nonatomic, strong)NSString *accessToken;
//expires_in
@property(nonatomic, strong)NSString *expiresIn;
//expires_time
@property(nonatomic, strong)NSDate *expiresTime;
//uid
@property(nonatomic, strong)NSString *uid;

- (instancetype)initWithString:(NSString *)jsonString;

- (void)saveAccount;

- (instancetype)initWithArchiever;

@end
