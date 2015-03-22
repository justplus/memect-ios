//
//  Geo.m
//  konggu
//
//  Created by zhaoliang on 15/3/11.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "Geo.h"
#import "NSDictionary+Json.h"

@implementation Geo

- (instancetype)initWithDictionary:(NSDictionary *)geo
{
    self = [super init];
    if (self) {
        NSArray *coordinatesArray = [geo arrayValueForKey:@"coordinates"];
        if (coordinatesArray && coordinatesArray.count == 2) {
            self.latitude = [[coordinatesArray objectAtIndex:0] doubleValue];
            self.longitude = [[coordinatesArray objectAtIndex:1] doubleValue];
        }
    }
    return self;
}

@end
