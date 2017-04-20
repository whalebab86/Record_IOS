//
//  DateSource.h
//  Record
//
//  Created by CLAY on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateSource : NSObject

+ (NSDate *)dateOfToday;
+ (NSString *)convertWithDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)convertDateToString:(NSDate *)date;
+ (NSDate *)convertStringToDate:(NSString *)dateString;
+ (NSComparisonResult)comparWithFromDate:(NSDate *)fromDate withToDate:(NSDate *)toDate;
+ (NSString *)componentsWithFromDate:(NSDate *)fromDate withToDate:(NSDate *)toDate;
+ (NSString *)calculateWithFromDate:(NSDate *)fromDate withToDate:(NSDate *)toDate;
+ (NSString *)formattedDateToMonth:(NSString *)date;

@end
