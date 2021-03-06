//
//  RCDiaryData.m
//  Record
//
//  Created by CLAY on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryData.h"

@implementation RCDiaryData

- (instancetype)initDiatyDataWithNSDictionary:(NSDictionary *)diaryInfo
{
    self = [super init];
    if (self) {
        
        self.diaryCoverImageUrl = [diaryInfo objectForKey:@"diaryCoverImageUrl"];
        self.diaryName          = [diaryInfo objectForKey:@"diaryName"];
        self.diaryStartDate     = [diaryInfo objectForKey:@"diaryStartDate"];
        self.diaryEndDate       = [diaryInfo objectForKey:@"diaryEndDate"];
        self.inDiaryCount       = [[diaryInfo objectForKey:@"inDiaryCount"] integerValue];        
//        self.diaryStartDateOriginal = [[diaryInfo objectForKey:@"diaryStartDateOriginal"] date];
//        self.diaryEndDateOriginal   = [[diaryInfo objectForKey:@"diaryEndDateOriginal"] date];
    }
    return self;
}

@end


@implementation RCInDiaryData

- (instancetype)initInDiatyDataWithNSDictionary:(NSDictionary *)diaryInfo {
    
    self = [super init];
    if (self) {
        self.inDiaryMainLoacation = [diaryInfo objectForKey:@"inDiaryMainLoacation"];
        self.inDiarySubLocation   = [diaryInfo objectForKey:@"inDiarySubLocation"];
        self.inDiaryDay           = [diaryInfo objectForKey:@"inDiaryDay"];
        self.inDiaryWriteDate     = [diaryInfo objectForKey:@"inDaryWriteDate"];
        self.inDiaryContent       = [diaryInfo objectForKey:@"inDaryContent"];
        self.inDiaryCoverImgUrl   = [diaryInfo objectForKey:@"inDiaryCoverImgUrl"];
        
        self.inDiaryLatitude      = [diaryInfo objectForKey:@"inDiaryLatitude"];
        self.inDiarylongitude     = [diaryInfo objectForKey:@"inDiarylongitude"];
    }
    return self;
}

@end
