//
//  DateSource.m
//  Record
//
//  Created by CLAY on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "DateSource.h"

@implementation DateSource

+ (NSDate *)dateOfToday {
    
    return [NSDate date];
}

+ (NSString *)convertWithDate:(NSDate *)date format:(NSString *)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)convertDateToString:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    return formattedDate;
}

+ (NSDate *)convertStringToDate:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *formattedDate = [dateFormatter dateFromString:dateString];
    
    if([dateString isEqualToString:@""]) {
        formattedDate = [NSDate date];
    }
    
    return formattedDate;
}

+ (NSComparisonResult)comparWithFromDate:(NSDate *)fromDate withToDate:(NSDate *)toDate {
    
    NSComparisonResult result = [fromDate compare:toDate];
    
    return result;
}

+ (NSString *)calculateWithFromDate:(NSDate *)fromDate withToDate:(NSDate *)toDate {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    /* from day - to day */
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    
    /* today - to day */
    NSDateComponents *components2 = [gregorianCalendar components:NSCalendarUnitDay
                                                         fromDate:fromDate
                                                           toDate:[NSDate date]
                                                          options:0];
    
    NSString *result = @"";
    
    if(components.day <= components2.day) {
        
        result = [NSString stringWithFormat:@"%ld", components.day+1];
        
    } else {
        
        result = [NSString stringWithFormat:@"%ld/%ld", (components2.day >= 0 ? components2.day : 0), components.day+1];
    }
    
    return result;
}

+ (NSString *)formattedDateToMonth:(NSString *)date
{
    
    NSInteger month = [[[date componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue];
    
    NSString *monthString = @"";
    
    switch (month) {
        case 1:
            monthString = @"january";
            break;
        
        case 2:
            monthString = @"february";
            break;
        
        case 3:
            monthString = @"march";
            break;
            
        case 4:
            monthString = @"april";
            break;
            
        case 5:
            monthString = @"may";
            break;
            
        case 6:
            monthString = @"june";
            break;
            
        case 7:
            monthString = @"july";
            break;
            
        case 8:
            monthString = @"august";
            break;
            
        case 9:
            monthString = @"september";
            break;
            
        case 10:
            monthString = @"october";
            break;
            
        case 11:
            monthString = @"november";
            break;
            
        case 12:
            monthString = @"december";
            break;
            
        default:
            break;
    }
    
    return monthString;
}

@end
