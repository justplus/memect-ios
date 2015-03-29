//
//  Account.m
//  kongku
//
//  Created by zhaoliang on 15/3/7.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "Account.h"
#import "NSDictionary+Json.h"
#import "MERequestTool.h"

#define ACCOUNT_FILE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"memect_account.plist"]
#define GET_USER_URL    @"https://api.weibo.com/2/users/show.json"

@implementation Account


#pragma mark - nscoding delegate
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.accessToken = [aDecoder decodeObjectForKey:@"access_token"];
        self.expiresIn = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeInt64ForKey:@"uid"];
        self.expiresTime = [aDecoder decodeObjectForKey:@"expires_time"];
        self.userInfo = [aDecoder decodeObjectForKey:@"user_info"];
        self.memectTypes = [aDecoder decodeObjectForKey:@"memect_types"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"access_token"];
    [aCoder encodeObject:self.expiresIn forKey:@"expires_in"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expiresTime forKey:@"expires_time"];
    [aCoder encodeObject:self.userInfo forKey:@"user_info"];
    [aCoder encodeObject:self.memectTypes forKey:@"memect_types"];
}

#pragma mark - initilization
- (instancetype)initWithDictionary:(NSDictionary *)account {
    self = [super init];
    if (self) {
        self.accessToken = [account stringValueForKey:@"access_token"];
        self.expiresIn = [account stringValueForKey:@"expires_in"];
        self.uid = [account longLongValueForKey:@"uid"];
        self.expiresTime = [[NSDate date] dateByAddingTimeInterval:self.expiresIn.doubleValue];
    }
    return self;
}

- (instancetype)initWithString:(NSString *)jsonString {
    self = [super init];
    if (self) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return [self initWithDictionary:dict];
    }
    return self;
}

#pragma mark - get and set account
- (void)saveAccount {
    BOOL r = [NSKeyedArchiver archiveRootObject:self toFile:ACCOUNT_FILE_PATH];
}

- (instancetype)initWithArchiever {
    self = [super init];
    if (self) {
        self = [NSKeyedUnarchiver unarchiveObjectWithFile:ACCOUNT_FILE_PATH];
    }
    return self;
    
}

#pragma mark - property
/*- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    [self saveAccount];
}*/

/*- (void)setMemectTypes:(NSMutableArray *)memectTypes {
    _memectTypes = memectTypes;
    [self saveAccount];
}*/

@end
