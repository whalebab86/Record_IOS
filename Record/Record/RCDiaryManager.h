//
//  RCDiaryManager.h
//  Record
//
//  Created by CLAY on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCDiaryData.h"

typedef void (^NetworkTaskHandler)(BOOL isSuccess, id responseData);

@interface RCDiaryManager : NSObject

+ (instancetype)diaryManager;

/* Request diary list */
- (void)requestDiaryListWithCompletionHandler:(NetworkTaskHandler)completionHandler;

/* Request diary modify */
- (void)requestDiaryInsertWithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestDiaryUpdateWithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestDiaryDeleteWithCompletionHandler:(NetworkTaskHandler)completionHandler;

- (NSInteger)diaryNumberOfItems;
- (RCDiaryData *)diaryDataAtIndexPath:(NSIndexPath *)indexPath;

- (void)insertDiaryItemwithDiaryObject:(RCDiaryData *)diary;
- (void)updateDiaryItemAtIndexPaths:(NSIndexPath *)indexPath withDiaryObject:(RCDiaryData *)diary;
- (void)deleteDiaryItemAtIndexPaths:(NSIndexPath *)indexPath;

@end
