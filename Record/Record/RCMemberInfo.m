//
//  RCMemberInfo.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 18..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMemberInfo.h"
#import "RCLoginStaticHeader.h"

@implementation RCMemberInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.profileImageURL = [[NSUserDefaults standardUserDefaults] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
        self.homeTown = [[NSUserDefaults standardUserDefaults] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
        self.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
        self.introduction = [[NSUserDefaults standardUserDefaults] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
    }
    return self;
}

@end
