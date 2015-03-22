//
//  Geo.h
//  konggu
//
//  Created by zhaoliang on 15/3/11.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Geo : NSObject

@property(nonatomic, assign)double longitude;
@property(nonatomic, assign)double latitude;

- (instancetype)initWithDictionary:(NSDictionary *)geo;

@end
