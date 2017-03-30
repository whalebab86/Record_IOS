//
//  RCDiaryManager.m
//  Record
//
//  Created by CLAY on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryManager.h"

#import <AFNetworking.h>

@interface RCDiaryManager ()

@property (nonatomic) NSURLSessionDataTask *dataTask;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) AFHTTPSessionManager *manager;

@end

@implementation RCDiaryManager

+ (instancetype)movieManager {
    
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
        
        self.manager    = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
        self.serializer = [AFHTTPRequestSerializer serializer];
        
    }
    return self;
}

@end
