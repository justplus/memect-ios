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
