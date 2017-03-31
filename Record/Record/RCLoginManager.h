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

typedef  void (^LoginSuccessBlock) (BOOL isSucceess);
@interface RCLoginManager : NSObject

+ (instancetype)loginManager;

- (void)recivedGoogleUserInfo:(GIDGoogleUser *)user;

- (void)confirmFacebookLoginfromViewController:(UIViewController *)fromViewController
                                    complition:(LoginSuccessBlock)complition;
- (void)facebookLogoutComplition:(LoginSuccessBlock)complition;


- (void)localEmailPasswordInputEmail:(NSString *)email
                       inputPassword:(NSString *)password
                  isSucessComplition:(LoginSuccessBlock)complition;


@end
