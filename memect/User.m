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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithLongLong:self.id] forKey:@"id"];
    [encoder encodeObject:self.idStr forKey:@"id_str"];
    [encoder encodeObject:self.screenName forKey:@"screen_name"];
    [encoder encodeObject:self.name forKey:@"name"];
    //[encoder encodeObject:self.province forKey:@"province"];
    //[encoder encodeObject:self.city forKey:@"city"];
    /*[encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.descriptions forKey:@"description"];*/
    [encoder encodeObject:self.profileImageUrl forKey:@"profile_image_url"];
    [encoder encodeObject:self.avatarLarge forKey:@"avatar_large"];
    [encoder encodeObject:self.avatarHD forKey:@"avatart_hd"];
    /*[encoder encodeObject:self.vertifyReason forKey:@"verify_reason"];
    [encoder encodeInt:self.gender forKey:@"gender"];
    [encoder encodeInt:self.followersCount forKey:@"followers_count"];
    [encoder encodeInt:self.friendsCount forKey:@"friends_count"];
    [encoder encodeInt:self.statusesCount forKey:@"statuses_count"];
    [encoder encodeInt:self.favouritesCount forKey:@"favorites_count"];
    [encoder encodeInt:self.biFollowersCount forKey:@"bi_followers_count"];
    [encoder encodeInt:self.createTime forKey:@"create_time"];
    [encoder encodeBool:self.hasFollowedMe forKey:@"following"];
    [encoder encodeBool:self.hasFollowed forKey:@"followed_by"];
    [encoder encodeBool:self.vertifyType forKey:@"vertify_type"];
    [encoder encodeInt:self.online forKey:@"online"];*/
    //[encoder encodeObject:self.avatarLarge forKey:@"avatar_large"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setId:[[decoder decodeObjectForKey:@"id"] longLongValue]];
        self.idStr = [decoder decodeObjectForKey:@"id_str"];
        self.screenName = [decoder decodeObjectForKey:@"screen_name"];
        self.name = [decoder decodeObjectForKey:@"name"];
        //self.province = [decoder decodeIntForKey:@"province"];
        //self.city = [decoder decodeIntForKey:@"city"];
        /*self.location = [decoder decodeObjectForKey:@"location"];
        self.descriptions = [decoder decodeObjectForKey:@"description"];*/
        self.profileImageUrl = [decoder decodeObjectForKey:@"profile_image_url"];
        self.avatarHD = [decoder decodeObjectForKey:@"avatar_hd"];
        self.avatarLarge = [decoder decodeObjectForKey:@"avatar_large"];
        /*self.vertifyReason = [decoder decodeObjectForKey:@"verify_reason"];
        self.gender = [decoder decodeIntForKey:@"gender"];
        self.followersCount = [decoder decodeIntForKey:@"followers_count"];
        self.friendsCount = [decoder decodeIntForKey:@"friends_count"];
        self.statusesCount = [decoder decodeIntForKey:@"statuses_count"];
        self.favouritesCount = [decoder decodeIntForKey:@"favorites_count"];
        self.biFollowersCount = [decoder decodeIntForKey:@"bi_followers_count"];
        self.createTime = [decoder decodeIntForKey:@"createTime"];
        self.hasFollowedMe = [decoder decodeBoolForKey:@"following"];
        self.vertifyType = [decoder decodeBoolForKey:@"followed_by"];
        self.vertifyType = [decoder decodeIntForKey:@"vertify_type"];
        self.online = [decoder decodeIntForKey:@"online"];*/
        //self.avatarLarge = [decoder decodeObjectForKey:@"avatar_large"];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)user {
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
        //self.province = [user intValueForKey:@"province"];
        //self.city = [user intValueForKey:@"city"];
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
