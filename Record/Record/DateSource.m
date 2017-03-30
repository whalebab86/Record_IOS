//
//  DateSource.m
//  Record
//
//  Created by CLAY on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "DateSource.h"

@implementation DateSource

+ (NSString *)dateFormatWithDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
    
}

@end
