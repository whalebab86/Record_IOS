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
- (void)requestDiaryInsertWithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestDiaryUpdateWithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestDiaryDeleteWithCompletionHandler:(NetworkTaskHandler)completionHandler;

/* Diary method */
- (NSInteger)diaryNumberOfItems;
- (RCDiaryData *)diaryDataAtIndexPath:(NSIndexPath *)indexPath;

- (void)insertDiaryItemwithDiaryObject:(RCDiaryData *)diary;
- (void)updateDiaryItemAtIndexPaths:(NSIndexPath *)indexPath withDiaryObject:(RCDiaryData *)diary;
- (void)deleteDiaryItemAtIndexPaths:(NSIndexPath *)indexPath;



/* In diary method */
- (NSMutableArray *)inDiaryAllData;
- (NSInteger)inDiaryNumberOfItems;
- (NSInteger)inDiaryNumberOfCoverItemsAtIndexPath:(NSIndexPath *)indexPath;
- (RCInDiaryData *)inDiaryDataAtIndexPath:(NSIndexPath *)indexPath;

- (void)insertInDiaryItemwithDiaryObject:(RCInDiaryData *)inDiary;
- (void)updateInDiaryItemAtIndexPaths:(NSIndexPath *)indexPath withDiaryObject:(RCInDiaryData *)inDiary;
- (void)deleteInDiaryItemAtIndexPaths:(NSIndexPath *)indexPath;
- (void)clearInDiaryItemAtIndexPaths;

/* Request in diary list */
- (void)requestInDiaryListWithCompletionHandler:(NetworkTaskHandler)completionHandler;
//- (void)requestInDiaryInsertWithCompletionHandler:(NetworkTaskHandler)completionHandler;
//- (void)requestDiaryUpdateWithCompletionHandler:(NetworkTaskHandler)completionHandler;
//- (void)requestDiaryDeleteWithCompletionHandler:(NetworkTaskHandler)completionHandler;

@end
