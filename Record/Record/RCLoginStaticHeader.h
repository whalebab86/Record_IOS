//
//  RCLoginStaticHeader.h
//  Record
//
//  Created by abyssinaong on 2017. 4. 4..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef RCLoginStaticHeader_h
#define RCLoginStaticHeader_h

static NSString * const _RECORD_ADDRESS = @"https://studydev.kr";
static NSString * const _RECORD_SIGNUP_API = @"/api/users/";
static NSString * const _RECORD_SIGNIN_API = @"/user/login/";
static NSString * const _RECORD_LOGOUT_API = @"/user/logout/";
static NSString * const _RECORD_PROFILECHANGE_API = @"/user/changeprofile/";
static NSString * const _RECORD_CHECK_VALID_TOKEN_API = @"/user/token/";
static NSString * const _RECORD_CHANGE_PROFILE_INFORMATION = @"/user/changepersonal/";
static NSString * const _RECORD_KEYCHAINITEMWRAPPER_KEY = @"keychainItemWrapperIdentifier"; 
static NSString * const _RECORD_ACCESSTOKEN_KEY = @"key";
static NSString * const _RECORD_SIGNUP_NAME_KEY = @"username";
static NSString * const _RECORD_SIGNUP_PASSWORD_KEY = @"password";
static NSString * const _RECORD_SIGNUP_NICKNAME_KEY = @"nickname";
static NSString * const _RECORD_SIGNUP_USER_TYPE_KEY = @"user_type";
static NSString * const _RECORD_SIGNUP_USER_TYPE_NORMAL = @"NORMAL";
static NSString * const _RECORD_SIGNUP_USER_TYPE_FACEBOOK = @"FACEBOOK";
static NSString * const _RECORD_SIGNUP_USER_TYPE_GOOGLE = @"GOOGLE";
static NSString * const _RECORD_SOCIAL_LOGIN_ACCESS_TOKEN_KEY = @"access_token";
static NSString * const _RECORD_LOGOUT_PARAMETER_KEY = @"Authorization";
static NSString * const _RECORD_PROFILECHANGE_PARAMETER_KEY = @"Authorization";
static NSString * const _RECORD_CHANGE_PROFILE_IMAGE_URL = @"profile_img";
static NSString * const _RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY = @"hometown";
static NSString * const _RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY = @"nickname";
static NSString * const _RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY = @"introduction";
#endif /* RCLoginStaticHeader_h */
