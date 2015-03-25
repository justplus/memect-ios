//
//  MemectThread.m
//  memect
//
//  Created by zhaoliang on 15/3/23.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "MemectThread.h"
#import "NSDictionary+Json.h"
#import "Status.h"

@implementation MemectThread

- (instancetype)initWithDictionary:(NSDictionary *)thread {
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] init];
        self.tags = [thread arrayValueForKey:@"tags"];
        self.weiboContent = [[Status alloc] initWithJsonString:[thread stringValueForKey:@"weibo_content"]];
        self.category = [thread intValueForKey:@"memect_category"];
        self.createDate = [thread stringValueForKey:@"create_time"];
        self.id = [thread longLongValueForKey:@"id"];
        self.weiboId = [thread longLongValueForKey:@"weibo_id"];
    }
    return self;
}

@end
