//
//  RCSettingTableInfo.h
//  Record
//
//  Created by abyssinaong on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCSettingTableInfo : NSObject

@property NSInteger sectionCount;
@property NSArray *sectionTitleArray;

@property NSInteger accountSectionRowCount;
@property NSArray *accountSectionTitleArray;

@property NSInteger supportSectionRowCount;
@property NSArray *supportSectionTitleArray;

@end
