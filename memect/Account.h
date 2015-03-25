//
//  Account.h
//  kongku
//
//  Created by zhaoliang on 15/3/7.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

@property(nonatomic, strong)NSString *accessToken;
@property(nonatomic, strong)NSString *expiresIn;
@property(nonatomic, strong)NSDate *expiresTime;
@property(nonatomic, assign)long long uid;

- (instancetype)initWithDictionary:(NSDictionary *)account;
- (instancetype)initWithString:(NSString *)jsonString;
- (void)saveAccount;
- (instancetype)initWithArchiever;

@end
