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
+ (NSString *)convertDateToString:(NSDate *)date;
+ (NSDate *)convertStringToDate:(NSString *)dateString;
+ (NSComparisonResult)comparWithFromDate:(NSString *)fromDate withToDate:(NSString *)toDate;
+ (NSString *)calculateWithFromDate:(NSString *)fromDate withToDate:(NSString *)toDate;
+ (NSString *)formattedDateToMonth:(NSString *)date;

@end
