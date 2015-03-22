//
//  User.h
//  konggu
//
//  Created by zhaoliang on 15/3/11.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Unknow = 0,
    Male,
    Female
}Gender;

typedef enum
{
    Offline = 0,
    Online = 1
}OnlineState;

typedef enum
{
    UnVertify,
    Start,
    Orgnization
}Vertify;

@interface User : NSObject

@property(nonatomic, assign)long long id;
@property(nonatomic, copy)NSString *idStr;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *screenName;
@property(nonatomic, copy)NSString *profileImageUrl;    //50x50
@property(nonatomic, copy)NSString *avatarHD;           //80x80
@property(nonatomic, copy)NSString *avatarLarge;        //180x180
@property(nonatomic, assign)Gender gender;
@property(nonatomic, assign)int province;
@property(nonatomic, assign)int city;
@property(nonatomic, copy)NSString *descriptions;
@property(nonatomic, assign)BOOL hasFollowedMe;
@property(nonatomic, assign)BOOL hasFollowed;
@property(nonatomic, assign)int favouritesCount;
@property(nonatomic, assign)int statusesCount;
@property(nonatomic, assign)int followersCount;
@property(nonatomic, assign)int friendsCount;
@property(nonatomic, assign)int biFollowersCount;
@property(nonatomic, assign)time_t createTime;
@property(nonatomic, copy)NSString *location;
@property(nonatomic, assign)OnlineState online;
@property(nonatomic, assign)Vertify vertifyType;
@property(nonatomic, copy)NSString *vertifyReason;


- (instancetype)initWithDictionary:(NSDictionary *)user;

@end
