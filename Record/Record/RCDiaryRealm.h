//
//  RCInDiaryRealm.h
//  Record
//
//  Created by CLAY on 2017. 4. 13..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Realm/Realm.h>

RLM_ARRAY_TYPE(RCDiaryRealm)
RLM_ARRAY_TYPE(RCInDiaryRealm)
RLM_ARRAY_TYPE(RCInDiaryPhotoRealm)


@interface RCInDiaryPhotoRealm : RLMObject

@property (nonatomic) NSData   *inDiaryPhoto;
@property (nonatomic) NSDate   *CreateDate;

@end

@interface RCInDiaryRealm : RLMObject

@property (nonatomic) NSString     *diaryPk;
@property (nonatomic) NSString     *inDiaryPk;
@property (nonatomic) NSString     *inDiaryLocationName;
@property (nonatomic) NSNumber<RLMFloat>     *inDiaryLocationLatitude;
@property (nonatomic) NSNumber<RLMFloat>     *inDiaryLocationLongitude;
@property (nonatomic) NSString     *inDiaryLocationCountry;

@property (nonatomic) NSString     *inDiaryContent;

@property (nonatomic) NSDate       *inDiaryReportingDate;
@property (nonatomic) NSDate       *inDiaryCreateDate;

@property (nonatomic) RLMArray<RCInDiaryPhotoRealm *><RCInDiaryPhotoRealm> *inDiaryPhotosArray;

@end


@interface RCDiaryRealm : RLMObject

@property (nonatomic) NSString *diaryPk;
@property (nonatomic) NSData   *diaryCoverImage;
@property (nonatomic) NSString *diaryName;
@property (nonatomic) NSDate   *diaryStartDate;
@property (nonatomic) NSDate   *diaryEndDate;

@property (nonatomic) NSDate   *diaryCreateDate;

@property (nonatomic) RLMArray<RCInDiaryRealm *><RCInDiaryRealm> *inDiaryArray;

@end
