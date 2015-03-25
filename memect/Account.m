//
//  Account.m
//  kongku
//
//  Created by zhaoliang on 15/3/7.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "Account.h"
#import "NSDictionary+Json.h"

#define ACCOUNT_FILE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"memect_account.plist"]

@implementation Account


#pragma mark - coder and decoder
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.accessToken = [aDecoder decodeObjectForKey:@"access_token"];
        self.expiresIn = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeInt64ForKey:@"uid"];
        self.expiresTime = [aDecoder decodeObjectForKey:@"expires_time"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"access_token"];
    [aCoder encodeObject:self.expiresIn forKey:@"expires_in"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expiresTime forKey:@"expires_time"];
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
    [NSKeyedArchiver archiveRootObject:self toFile:ACCOUNT_FILE_PATH];
}

- (instancetype)initWithArchiever {
    self = [super init];
    if (self) {
        self = [NSKeyedUnarchiver unarchiveObjectWithFile:ACCOUNT_FILE_PATH];
    }
    return self;
    
}

@end
