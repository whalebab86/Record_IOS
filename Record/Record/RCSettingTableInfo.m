//
//  RCSettingTableInfo.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSettingTableInfo.h"

static NSString * const _SETTING_SECTIONTITLE_KEY = @"SectionTitle";
static NSString * const _SETTING_SUPPORTSECTION_KEY = @"SuportSection";
static NSString * const _SETTING_ACCOUNTSECTION_KEY = @"AccountSection";

@interface RCSettingTableInfo()

@property NSDictionary *settingRootDic;

@end

@implementation RCSettingTableInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self settingRootDicWithPlist];
        [self setSectionCountWithSettingRootDic];
        [self accountSectionRowCountWithSettingRootDic];
        [self accountSectionTitleArrayWithSettingRootDic];
        [self supportSectionRowCountWithSettingRootDic];
        [self supportSectionTitleArrayWithSettingRootDic];
    }
    return self;
}

- (NSString *)rcSettingPlistPath {
    return [[NSBundle mainBundle] pathForResource:@"RCSettingTable" ofType:@"plist"];
}

- (void)settingRootDicWithPlist {
    self.settingRootDic = [NSDictionary dictionaryWithContentsOfFile:[self rcSettingPlistPath]];
}

- (void)setSectionCountWithSettingRootDic {
    self.sectionCount = [[self.settingRootDic objectForKey:_SETTING_SECTIONTITLE_KEY] count];
    self.sectionTitleArray = [self.settingRootDic objectForKey:_SETTING_SECTIONTITLE_KEY];
}

- (void)accountSectionRowCountWithSettingRootDic {
    self.accountSectionRowCount = [[[self.settingRootDic objectForKey:_SETTING_ACCOUNTSECTION_KEY] objectForKey:@"Title"] count];
}

- (void)accountSectionTitleArrayWithSettingRootDic {
    self.accountSectionTitleArray = [[self.settingRootDic objectForKey:_SETTING_ACCOUNTSECTION_KEY] objectForKey:@"Title"];
}

- (void)supportSectionRowCountWithSettingRootDic {
    self.supportSectionRowCount = [[[self.settingRootDic objectForKey:_SETTING_SUPPORTSECTION_KEY] objectForKey:@"Title"] count];
}

- (void)supportSectionTitleArrayWithSettingRootDic {
    self.supportSectionTitleArray = [[self.settingRootDic objectForKey:_SETTING_SUPPORTSECTION_KEY] objectForKey:@"Title"];
}

@end
