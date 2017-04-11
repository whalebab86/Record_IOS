//
//  RCDiaryData.h
//  Record
//
//  Created by CLAY on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDiaryData : NSObject

@property (nonatomic) NSString *diaryCoverImageUrl;
@property (nonatomic) NSString *diaryName;
@property (nonatomic) NSString *diaryStartDate;
@property (nonatomic) NSString *diaryEndDate;
@property (nonatomic) NSInteger inDiaryCount;

@property (nonatomic) NSDate *diaryStartDateOriginal;
@property (nonatomic) NSDate *diaryEndDateOriginal;

- (instancetype)initDiatyDataWithNSDictionary:(NSDictionary *)diaryInfo;

@end


@interface RCInDiaryData : NSObject

@property (nonatomic) NSString *inDiaryMainLoacation;
@property (nonatomic) NSString *inDiarySubLocation;
@property (nonatomic) NSString *inDiaryDay;
@property (nonatomic) NSString *inDiaryWriteDate;
@property (nonatomic) NSString *inDiaryContent;
@property (nonatomic) NSArray  *inDiaryCoverImgUrl;

@property (nonatomic) NSString *inDiaryLatitude;
@property (nonatomic) NSString *inDiarylongitude;

- (instancetype)initInDiatyDataWithNSDictionary:(NSDictionary *)diaryInfo;

@end
