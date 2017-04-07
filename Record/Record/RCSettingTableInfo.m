//
//  RCSettingTableInfo.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSettingTableInfo.h"

static NSString * const _SETTING_SECTIONTITLE_KEY = @"SectionTitle";
static NSString * const _SETTING_SUPPORTSECTION_KEY = @"SupportSection";
static NSString * const _SETTING_ACCOUNTSECTION_KEY = @"AccountSection";
static NSString * const _SETTING_SUPPORT_CONTENT_KEY = @"SupportContent";

@interface RCSettingTableInfo()

@property NSDictionary *settingRootDic;

@end

@implementation RCSettingTableInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self settingRootDictionary];
        [self setDefaultWithSettingRootDic];
        [self accountSectionWithSettingRootDic];
        [self supportSectionWithSettingRootDic];
    }
    return self;
}

- (void)settingRootDictionary {
    
    self.settingRootDic = @{ _SETTING_SECTIONTITLE_KEY  : @[@"ACCOUNT", @"SUPPORT"],
                             _SETTING_ACCOUNTSECTION_KEY: @[@"My profile", @"My Travel Diarys"],
                             _SETTING_SUPPORTSECTION_KEY: @[@"Support"],
                             _SETTING_SUPPORT_CONTENT_KEY:@"김윤서 \nhttps://github.com/KimYunseo \n\n\n조봉기 \nhttps://github.com/whalebab86"};//webview 연동!
    
}

- (void)setDefaultWithSettingRootDic {
    self.sectionCount = [[self.settingRootDic objectForKey:_SETTING_SECTIONTITLE_KEY] count];
    self.sectionTitleArray = [self.settingRootDic objectForKey:_SETTING_SECTIONTITLE_KEY];
}

- (void)accountSectionWithSettingRootDic {
    self.accountSectionRowCount = [[self.settingRootDic objectForKey:_SETTING_ACCOUNTSECTION_KEY] count];
    self.accountSectionTitleArray = [self.settingRootDic objectForKey:_SETTING_ACCOUNTSECTION_KEY];
}

- (void)supportSectionWithSettingRootDic {
    self.supportSectionRowCount = [[self.settingRootDic objectForKey:_SETTING_SUPPORTSECTION_KEY] count];
    self.supportSectionTitleArray = [self.settingRootDic objectForKey:_SETTING_SUPPORTSECTION_KEY];
    self.supportContentString = [self.settingRootDic objectForKey:_SETTING_SUPPORT_CONTENT_KEY];
}

@end
