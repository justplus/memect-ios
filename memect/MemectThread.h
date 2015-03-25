//
//  MemectThread.h
//  memect
//
//  Created by zhaoliang on 15/3/23.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"

@interface MemectThread : NSObject

// 标签列表
@property(nonatomic, copy)NSArray *tags;
// 内容
@property(nonatomic, strong)Status *weiboContent;
// 分类 0-焦点 1-动态
@property(nonatomic, assign)int category;
// 发布时间
@property(nonatomic, strong)NSString *createDate;
// 编号
@property(nonatomic, assign)long long id;
// 微博编号
@property(nonatomic, assign)long long weiboId;

- (instancetype)initWithDictionary:(NSDictionary *)thread;

@end
