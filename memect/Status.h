//
//  Status.h
//  konggu
//
//  Created by zhaoliang on 15/3/11.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Status : NSObject

@property(nonatomic, assign)long long tid;
@property(nonatomic, assign)long long mid;
@property(nonatomic, copy)NSString *idStr;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, strong)NSArray *originalPics;
@property(nonatomic, strong)NSArray *bMiddlePics;
@property(nonatomic, strong)NSArray *thumbnailPics;
@property(nonatomic, assign)int commentsCount;
@property(nonatomic, assign)int attitudesCount;
@property(nonatomic, assign)int repostsCount;
@property(nonatomic, assign)time_t createTime;
@property(nonatomic, assign)BOOL hasFavorited;
@property(nonatomic, copy)NSString *source;
@property(nonatomic, strong)User *user;
@property(nonatomic, strong)Status *retweetedStatus;

- (instancetype)initWithDictionary:(NSDictionary *)status;

@end
