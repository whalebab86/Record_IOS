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


typedef  void (^SuccessStateBlock) (BOOL isSucceess, NSInteger code);
@interface RCLoginManager : NSObject

@property (readonly) NSString *serverAccessKey;
@property (readonly) BOOL isValidToken;

+ (instancetype)loginManager;

- (void)recivedForGoogleSignupUserInfo:(GIDGoogleUser *)user
                   complition:(SuccessStateBlock)complition;

- (void)recivedForGoogleLoginWithUserInfo:(GIDGoogleUser *)user
                               complition:(SuccessStateBlock)complition;

- (void)confirmFacebookSignupfromViewController:(UIViewController *)fromViewController
                                     complition:(SuccessStateBlock)complition;

- (void)confirmFacebookLoginfromViewController:(UIViewController *)fromViewController
                                    complition:(SuccessStateBlock)complition;

- (void)facebookLogout;


- (void)localEmailPasswordInputEmail:(NSString *)email
                       inputPassword:(NSString *)password
                  isSucessComplition:(SuccessStateBlock)complition;

- (void)localSignupInputEmail:(NSString *)email
                inputPassword:(NSString *)password
                inputNickName:(NSString *)nickName
                   complition:(SuccessStateBlock)complition;

- (void)logoutWithComplition:(SuccessStateBlock)complition;

- (void)checkValidTokenWithComplition:(SuccessStateBlock)complition;

- (void)uploadProfileImageWithUIImage:(UIImage *)image
                           complition:(SuccessStateBlock)complition;

- (void)uploadProfilePersonalInformationWithNickname:(NSString *)nickname
                                            hometown:(NSString *)hometown
                                    selfIntroduction:(NSString *)introdution
                                          complition:(SuccessStateBlock)complition;
@end
