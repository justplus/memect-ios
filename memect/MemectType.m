//
//  MemectType.m
//  memect
//
//  Created by zhaoliang on 15/3/26.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "MemectType.h"
#import "NSDictionary+Json.h"

#define ACCOUNT_FILE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"memect_types.plist"]

@implementation MemectType

#pragma mark - nscoding delegate
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.abbr = [aDecoder decodeObjectForKey:@"abbr"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.icon = [aDecoder decodeObjectForKey: @"icon"];
        self.hasSubscribe = [aDecoder decodeBoolForKey:@"has_subscribe"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.abbr forKey:@"abbr"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeBool:self.hasSubscribe forKey:@"has_subscribe"];
}

- (instancetype)initWithDictionary:(NSDictionary *)type {
    self = [super init];
    if (self) {
        self.id = [type intValueForKey:@"id"];
        self.name = [type stringValueForKey:@"name"];
        self.abbr = [type stringValueForKey:@"abbr"];
        self.url = [type stringValueForKey:@"url"];
        self.icon = [type stringValueForKey:@"icon"];
        self.hasSubscribe = [type boolValueForKey:@"has_subscribe"];
    }
    return self;
}

@end
