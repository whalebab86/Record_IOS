//
//  RCInDiaryRealm.m
//  Record
//
//  Created by CLAY on 2017. 4. 13..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryRealm.h"

@implementation RCDiaryRealm

+(NSString *)primaryKey {
    return @"diaryPk";
}

@end

@implementation RCInDiaryRealm

+(NSString *)primaryKey {
    return @"inDiaryPk";
}

@end

@implementation RCInDiaryPhotoRealm

@end
