//
//  MemectType.h
//  memect
//
//  Created by zhaoliang on 15/3/26.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemectType : NSObject

// 编号
@property(nonatomic, assign)int id;
// 名称
@property(nonatomic, copy)NSString *name;
// 英文缩写
@property(nonatomic, copy)NSString *abbr;
// url
@property(nonatomic, copy)NSString *url;
// 图标
@property(nonatomic, copy)NSString *icon;
// 是否已订阅
@property(nonatomic, assign)BOOL hasSubscribe;

- (instancetype)initWithDictionary:(NSDictionary *)type;

@end
