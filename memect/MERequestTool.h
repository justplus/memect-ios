//
//  KGRequestTool.h
//  konggu
//
//  Created by zhaoliang on 15/3/8.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MERequestTool : NSObject

+ (void)GET:(NSString *)URLString
            parameters:(id)parameters
            response:(NSString *)response
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)URLString
            parameters:(id)parameters
            response:(NSString *)response
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

@end
