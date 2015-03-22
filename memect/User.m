//
//  User.m
//  konggu
//
//  Created by zhaoliang on 15/3/11.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "User.h"
#import "NSDictionary+Json.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)user
{
    self = [super init];
    if (self) {
        self.id = [user longLongValueForKey:@"id"];
        self.idStr = [user stringValueForKey:@"id_str"];
        self.name = [user stringValueForKey:@"name"];
        self.screenName = [user stringValueForKey:@"screen_name"];
        self.profileImageUrl = [user stringValueForKey:@"profile_image_url"];
        self.avatarHD = [user stringValueForKey:@"avatar_hd"];
        self.avatarLarge = [user stringValueForKey:@"avatar_large"];
        NSString *genderChar = [user stringValueForKey:@"gender"];
        if ([genderChar isEqualToString:@"m"]) {
            self.gender = Male;
        }
        else if ([genderChar isEqualToString:@"f"]) {
            self.gender = Female;
        }
        else {
            self.gender = Unknow;
        }
        self.province = [user intValueForKey:@"province"];
        self.city = [user intValueForKey:@"city"];
        self.descriptions = [user stringValueForKey:@"description"];
        self.hasFollowedMe = [user boolValueForKey:@"follow_me"];
        self.hasFollowed = [user boolValueForKey:@"following"];
        self.favouritesCount = [user intValueForKey:@"favourites_count"];
        self.statusesCount = [user intValueForKey:@"statuses_count"];
        self.followersCount = [user intValueForKey:@"followers_count"];
        self.friendsCount = [user intValueForKey:@"friends_count"];
        self.biFollowersCount = [user intValueForKey:@"bi_followers_count"];
        self.createTime = [user timeValueForKey:@"create_at"];
        self.location = [user stringValueForKey:@"location"];
        self.online = [user intValueForKey:@"online_status"];
        int vertify = [user intValueForKey:@"vertify_type"];
        if (vertify == -1) {
            self.vertifyType = UnVertify;
        }
        else if (vertify == 0) {
            self.vertifyType = Start;
        }
        else {
            self.vertifyType = Orgnization;
        }
        self.vertifyReason = [user stringValueForKey:@"vertify_reason"];
    }
    return self;
}

@end
