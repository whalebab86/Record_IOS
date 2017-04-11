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
static NSString * const _RECORD_SIGNIN_API = @"/rest-auth/login/";
static NSString * const _RECORD_LOGOUT_API = @"/rest-auth/logout/";
static NSString * const _RECORD_ACCESSTOKEN_KEY = @"key";
static NSString * const _RECORD_SIGNUP_NAME_KEY = @"username";
static NSString * const _RECORD_SIGNUP_PASSWORD_KEY = @"password";
static NSString * const _RECORD_SIGNUP_NICKNAME_KEY = @"nickname";
static NSString * const _RECORD_SIGNUP_USER_TYPE_KEY = @"user_type";
static NSString * const _RECORD_SIGNUP_USER_TYPE_NORMAL = @"NORMAL";
static NSString * const _RECORD_SIGNUP_USER_TYPE_FACEBOOK = @"FACEBOOK";
static NSString * const _RECORD_SIGNUP_USER_TYPE_GOOGLE = @"GOOGLE";
static NSString * const _RECORD_LOGOUT_PARAMETER_KEY = @"Authorization";
static NSString * const _RECORD_REQUEST_METHOD_POST = @"POST";
static NSString * const _RECORD_REQUEST_METHOD_GET = @"GET";

#endif /* RCLoginStaticHeader_h */
