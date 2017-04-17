//
//  RCDiaryManager.m
//  Record
//
//  Created by CLAY on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryManager.h"
#import <AFNetworking.h>
#import <Realm/Realm.h>

#import "RCDiaryRealm.h"

@interface RCDiaryManager ()

@property (nonatomic) AFURLSessionManager *sessionManager;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) NSURLSessionDataTask *dataTask;

@property (nonatomic) NSMutableArray      *diaryDataArray;

@property (nonatomic) NSMutableDictionary *inDiaryInfo;
@property (nonatomic) NSMutableArray      *inDiaryDataArray;

@end

@implementation RCDiaryManager

+ (instancetype)diaryManager {
    
    static RCDiaryManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RCDiaryManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        self.serializer = [AFHTTPRequestSerializer serializer];
        
        self.diaryDataArray   = [[NSMutableArray alloc] init];
        self.inDiaryDataArray = [[NSMutableArray alloc] init];
        
        self.inDiaryInfo      = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

#pragma mark - Configure Request [ Diary ]
/* Diary list select */
- (void)requestDiaryListWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    
    
    
//    [self readDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
//        
//        if(isSuccess) {
//            
//            NSDictionary *resultInfo = (NSDictionary *)responseData;
//            NSArray *diayList        = [resultInfo objectForKey:@"results"];
//            
//            for (NSDictionary *diaryInfo in diayList) {
//                
//                RCDiaryData *data = [[RCDiaryData alloc] initDiatyDataWithNSDictionary:diaryInfo];
//                [self.diaryDataArray addObject:data];
//            }
//            
//            completionHandler(isSuccess, responseData);
//        } else {
//            
//            completionHandler(isSuccess, nil);
//        }
//    }];
}

/* Diary info insert */
- (void)requestDiaryInsertWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    
    [self writeDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
        
        [self readDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
            
            completionHandler(isSuccess, responseData);
        }];
    }];
}


/* Diary info update */
- (void)requestDiaryUpdateWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    
    [self writeDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
        
        [self readDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
            
            completionHandler(isSuccess, responseData);
        }];
    }];
}

/* Diary info delete */
- (void)requestDiaryDeleteWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    
    [self writeDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
        
        [self readDictionaryFromWithFilepath:@"diary" andHandler:^(BOOL isSuccess, id responseData) {
            
            completionHandler(isSuccess, responseData);
        }];
    }];
}

/* json data read */
- (void)readDictionaryFromWithFilepath:(NSString *)filePathString andHandler:(NetworkTaskHandler)completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filePathString ofType:@"json"];
    
    NSData *partyData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //convert JSON NSData to a usable NSDictionary
    NSError *error;
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:partyData
                                                                 options:0
                                                                   error:&error];
    completionHandler(YES, responseData);
    
}

/* json data wirte */
- (void)writeDictionaryFromWithFilepath:(NSString *)filePathString andHandler:(NetworkTaskHandler)completionHandler {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (RCDiaryData *diary in self.diaryDataArray) {
        
        NSDictionary *dic = @{@"diaryName":diary.diaryName, @"diaryStartDate":diary.diaryStartDate
            , @"diaryEndDate":diary.diaryEndDate, @"inDiaryCount":[NSString stringWithFormat:@"%ld", diary.inDiaryCount]
            , @"diaryCoverImageUrl":@"http://www.city.kr/files/attach/images/1326/542/186/010/9bbd68054422876eb730b296963d0e82.jpg"
        };
        
        [tempArray addObject:dic];
    }
    
    NSDictionary *temp = @{
        @"count":@"10",
        @"results":tempArray
        };

    NSData *data       = [NSJSONSerialization dataWithJSONObject:temp options:kNilOptions error:nil];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:filePathString ofType:@"json"];
    
    [data writeToFile:filePath atomically:YES];
    
    completionHandler(YES, nil);
}



#pragma mark - Configure Request [ In diary ]
/* In diary list select */
- (void)requestInDiaryListWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    
    [self readDictionaryFromWithFilepath:@"inDiary" andHandler:^(BOOL isSuccess, id responseData) {
        
        if(isSuccess) {
            
            NSDictionary *resultInfo = (NSDictionary *)responseData;
            
            NSDictionary *inDiaryInfo   = [resultInfo objectForKey:@"diaryResult"];
            NSArray      *inDiaryArray  = [resultInfo objectForKey:@"inDiaryResults"];
            
            self.inDiaryInfo      = [inDiaryInfo mutableCopy];
            
            for (NSDictionary *diaryInfo in inDiaryArray) {
                
                RCInDiaryData *data = [[RCInDiaryData alloc] initInDiatyDataWithNSDictionary:diaryInfo];
                [self.inDiaryDataArray addObject:data];
            }
            
            completionHandler(isSuccess, responseData);
        } else {
            
            completionHandler(isSuccess, nil);
        }
        
    }];
}



#pragma mark - Provide Diary Data
- (NSInteger)diaryNumberOfItems {
    
    return self.diaryDataArray.count;
}

- (RCDiaryData *)diaryDataAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.diaryDataArray[indexPath.item];
}

- (void)insertDiaryItemwithDiaryObject:(RCDiaryData *)diary {
    
    [self.diaryDataArray insertObject:diary atIndex:0];
}

- (void)updateDiaryItemAtIndexPaths:(NSIndexPath *)indexPath withDiaryObject:(RCDiaryData *)diary {
    
    [self.diaryDataArray replaceObjectAtIndex:indexPath.row withObject:diary];
}

- (void)deleteDiaryItemAtIndexPaths:(NSIndexPath *)indexPath {
    
    [self.diaryDataArray removeObjectAtIndex:indexPath.row];
}


#pragma mark - Provide In Diary Data
- (NSMutableArray *)inDiaryAllData {
    
    return self.inDiaryDataArray;
}

- (NSInteger)inDiaryNumberOfItems {
    
    return self.inDiaryDataArray.count;
}

- (NSInteger)inDiaryNumberOfCoverItemsAtIndexPath:(NSIndexPath *)indexPath {
    
    return [((RCInDiaryData*)self.inDiaryDataArray[indexPath.row]).inDiaryCoverImgUrl count] ;
}

- (RCInDiaryData *)inDiaryDataAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.inDiaryDataArray[indexPath.item];
}

- (void)insertInDiaryItemwithDiaryObject:(RCDiaryData *)diary {
    
    [self.inDiaryDataArray insertObject:diary atIndex:0];
}

- (void)updateInDiaryItemAtIndexPaths:(NSIndexPath *)indexPath withDiaryObject:(RCDiaryData *)diary {
    
    [self.inDiaryDataArray replaceObjectAtIndex:indexPath.row withObject:diary];
}

- (void)deleteInDiaryItemAtIndexPaths:(NSIndexPath *)indexPath {
    
    [self.inDiaryDataArray removeObjectAtIndex:indexPath.row];
}

- (void)clearInDiaryItemAtIndexPaths {
    
    [self.inDiaryDataArray removeAllObjects];
}


@end
