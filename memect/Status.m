//
//  Status.m
//  konggu
//
//  Created by zhaoliang on 15/3/11.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "Status.h"
#import "User.h"
#import "NSDictionary+Json.h"
#include "NSDictionary_JSONExtensions.h"

@implementation Status

- (instancetype)initWithDictionary:(NSDictionary *)status {
    self = [super init];
    if (self) {
        self.tid = [status longLongValueForKey:@"id"];
        self.mid = [status longLongValueForKey:@"mid"];
        self.idStr = [status stringValueForKey:@"is_str"];
        self.text = [status stringValueForKey:@"text"];
        NSArray *pics = [status arrayValueForKey:@"pic_urls"];
        NSMutableArray *originalPics = [[NSMutableArray alloc] init];
        NSMutableArray *bmiddlePics = [[NSMutableArray alloc] init];
        NSMutableArray *thumbnailPics = [[NSMutableArray alloc] init];
        for (NSDictionary *thumbnailDict in pics) {
            NSString *thumbnail = [thumbnailDict stringValueForKey:@"thumbnail_pic"];
            NSRange range = [thumbnail rangeOfString:@"/thumbnail/"];
            [originalPics addObject:[thumbnail stringByReplacingCharactersInRange:range withString:@"/large/"]];
            [bmiddlePics addObject:[thumbnail stringByReplacingCharactersInRange:range withString:@"/bmiddle/"]];
            [thumbnailPics addObject:[thumbnail stringByReplacingCharactersInRange:range withString:@"/thumbnail/"]];
        }
        self.originalPics = originalPics;
        self.bMiddlePics = bmiddlePics;
        self.thumbnailPics = thumbnailPics;
        self.commentsCount = [status intValueForKey:@"comments_count"];
        self.attitudesCount = [status intValueForKey:@"attitudes_count"];
        self.repostsCount = [status intValueForKey:@"reposts_count"];
        self.createTime = [status timeValueForKey:@"create_at"];
        self.hasFavorited = [status boolValueForKey:@"favorited"];
        self.source = [status stringValueForKey:@"source"];
        NSDictionary *user = [status dictionaryValueForKey:@"user"];
        if (user) {
            self.user = [[User alloc] initWithDictionary:user];
        }
        NSDictionary *retweetedStatus = [status dictionaryValueForKey:@"retweeted_status"];
        if (retweetedStatus) {
            self.retweetedStatus = [[Status alloc] initWithDictionary:retweetedStatus];
        }
    }
    return self;
}

- (instancetype)initWithJsonString:(NSString *)statusJson {
    self = [super init];
    if (self) {
        // json字符串反序列化
        if (!statusJson) {
            return nil;
        }
        /*statusJson = [self escapeBlank:statusJson];
        NSData *data = [statusJson dataUsingEncoding:NSUTF8StringEncoding];*/
        statusJson = [self escapeSource:statusJson];
        NSError *err = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:statusJson error:&err];
        return [self initWithDictionary:dict];
    }
    return self;
}

- (NSString *)escapeSource:(NSString *)json {
    NSRegularExpression *regex;
    NSString *pattern = @"\"source\": \"<a href=.*?</a>\",";
    NSError *error = NULL;
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchResult = [regex matchesInString:json options:NSMatchingReportCompletion range:NSMakeRange(0, json.length)];
    for (NSTextCheckingResult *result in matchResult) {
        json = [json stringByReplacingCharactersInRange:
                NSMakeRange(result.range.location, result.range.length) withString:@""];
    }
    return json;
}
@end
