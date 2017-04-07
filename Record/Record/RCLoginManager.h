//
//  RCLoginManager.h
//  Record
//
//  Created by abyssinaong on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <Google/SignIn.h>
#import "RCLoginStaticHeader.h"


typedef  void (^LoginSuccessBlock) (BOOL isSucceess, NSInteger code);
@interface RCLoginManager : NSObject

+ (instancetype)loginManager;

- (void)recivedGoogleUserInfo:(GIDGoogleUser *)user
                   complition:(LoginSuccessBlock)complition;

- (void)confirmFacebookLoginfromViewController:(UIViewController *)fromViewController
                                    complition:(LoginSuccessBlock)complition;

- (void)facebookLogout;


- (void)localEmailPasswordInputEmail:(NSString *)email
                       inputPassword:(NSString *)password
                  isSucessComplition:(LoginSuccessBlock)complition;

- (void)localSignupInputEmail:(NSString *)email
                inputPassword:(NSString *)password
                inputNickName:(NSString *)nickName
                   complition:(LoginSuccessBlock)complition;

@end
