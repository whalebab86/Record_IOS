//
//  RCLoginManager.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <AFNetworking.h>
#import "RCLoginManager.h"
#import "KeychainItemWrapper.h"

@interface RCLoginManager()
<GIDSignInUIDelegate, GIDSignInUIDelegate>

@property NSString *serverAccessKey;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) AFHTTPSessionManager *manager;
@property (nonatomic) KeychainItemWrapper *keyChainWrapperInLoginManager;
@property (nonatomic) NSString *profileImageURL;

@end

@implementation RCLoginManager

+ (instancetype)loginManager{
    static RCLoginManager *login;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[RCLoginManager alloc] init];
    });
    return login;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager                             = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
        self.serializer                          = [AFHTTPRequestSerializer serializer];
        self.keyChainWrapperInLoginManager       = [[KeychainItemWrapper alloc] initWithIdentifier:_RECORD_KEYCHAINITEMWRAPPER_KEY accessGroup:nil];
        
    }
    
    return self;
    
}

#pragma mark - Google Sign up Method
/* recived user info from google and return status code */
- (void)recivedForGoogleSignupUserInfo:(GIDGoogleUser *)user
                            complition:(SuccessStateBlock)complition {
    // For client-side use only!
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:user.profile.email,
                                 _RECORD_SIGNUP_PASSWORD_KEY:@"",
                                 _RECORD_SIGNUP_NICKNAME_KEY:@"",
                                 _RECORD_SOCIAL_LOGIN_ACCESS_TOKEN_KEY:user.authentication.accessToken,
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_GOOGLE};
    
    NSString *urlString      =  [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                   
                   [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL]
                                                            forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
                   
                   complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                   complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               }];
}

#pragma mark - Google Login Method
- (void)recivedForGoogleLoginWithUserInfo:(GIDGoogleUser *)user
                               complition:(SuccessStateBlock)complition {
    
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:user.profile.email,
                                 _RECORD_SOCIAL_LOGIN_ACCESS_TOKEN_KEY:user.authentication.accessToken,
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_GOOGLE};
    
    NSString *urlString      = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNIN_API];
    
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                   [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL]
                                                            forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
                   
                   complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                   complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               }];
}


#pragma mark - Facebook Login Logout Method
/* facebook sign up */
- (void)confirmFacebookSignupfromViewController:(UIViewController *)fromViewController
                                     complition:(SuccessStateBlock)complition {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [self dispatchUserInfoFormFacebookForSignUp:complition];
        
    } else {
        FBSDKLoginManager *manger = [[FBSDKLoginManager alloc] init];
        [manger logInWithReadPermissions: @[@"public_profile",@"email"]
                      fromViewController:fromViewController
                                 handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                     if (error) {
                                         complition(NO, error.code);
                                     } else if (result.isCancelled) {
                                         [self dispatchUserInfoFormFacebookForSignUp:complition];
                                     } else {
                                         [self dispatchUserInfoFormFacebookForSignUp:complition];
                                     }
                                 }];
    }
}

/* facebook login */
- (void)confirmFacebookLoginfromViewController:(UIViewController *)fromViewController
                                    complition:(SuccessStateBlock)complition {
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [self dispatchUserInfoFormFacebookForSignUp:complition];
        
    } else {
        FBSDKLoginManager *manger = [[FBSDKLoginManager alloc] init];
        [manger logInWithReadPermissions: @[@"public_profile",@"email"]
                      fromViewController:fromViewController
                                 handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                     if (error) {
                                         complition(NO, error.code);
                                     } else if (result.isCancelled) {
                                         complition(NO, error.code);
                                     } else {
                                         [self dispatchUserInfoFormFacebookForLogin:complition];
                                     }
                                 }];
    }
}


/* facebook logout */
- (void)facebookLogout {
    
    FBSDKLoginManager *manger = [[FBSDKLoginManager alloc] init];
    
    [manger logOut];
    
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        
    }
}

/*  */
-(void)dispatchUserInfoFormFacebookForSignUp:(SuccessStateBlock)complition {
    FBSDKGraphRequest *requestMe            = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe
         completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if(result)
             {
                 NSDictionary *parameters   = @{_RECORD_SIGNUP_NAME_KEY:[FBSDKAccessToken currentAccessToken].userID,
                                                _RECORD_SIGNUP_PASSWORD_KEY:@"",
                                                _RECORD_SIGNUP_NICKNAME_KEY:@"",
                                                _RECORD_SOCIAL_LOGIN_ACCESS_TOKEN_KEY:[FBSDKAccessToken currentAccessToken].tokenString,
                                                _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_FACEBOOK};
                 
                 NSString *urlString        = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
                 [self.manager POST:urlString
                         parameters:parameters
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                                complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
                                
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
                     
                 }];
             }
         }];
    [connection start];
}

-(void)dispatchUserInfoFormFacebookForLogin:(SuccessStateBlock)complition {
    FBSDKGraphRequest *requestMe            = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe
         completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if(result)
             {
                 NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:[FBSDKAccessToken currentAccessToken].userID,
                                              _RECORD_SOCIAL_LOGIN_ACCESS_TOKEN_KEY:[FBSDKAccessToken currentAccessToken].tokenString,
                                              _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_FACEBOOK};
                 
                 NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNIN_API];
                 [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     
                     [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                     [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL]
                                                              forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
                     [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY]
                                                               forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
                     [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY]
                                                               forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
                     [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY]
                                                               forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
                     complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
                     
                 }];
             }
    }];
    [connection start];
}

#pragma mark - Email Login Method
- (void)localEmailPasswordInputEmail:(NSString *)email
                         inputPassword:(NSString *)password
                    isSucessComplition:(SuccessStateBlock)complition
{

    NSDictionary *parameters = @{@"username":email,
                                 @"password":password,
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_NORMAL};
    
    NSString *urlString      = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNIN_API];
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                   [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL]
                                                            forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY]
                                                             forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
                   
                   complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                   complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               }];
}

#pragma mark - Eamil Sign up Method

- (void)localSignupInputEmail:(NSString *)email
                inputPassword:(NSString *)password
                inputNickName:(NSString *)nickName
                   complition:(SuccessStateBlock)complition {
    
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:email,
                                 _RECORD_SIGNUP_PASSWORD_KEY:password,
                                 _RECORD_SIGNUP_NICKNAME_KEY:nickName,
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_NORMAL};
    
    NSString *urlString      = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                   
                   [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL] forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY] forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY] forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY] forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
                   
                   complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
        
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
    }];
}


#pragma mark - logout method

- (void)logoutWithComplition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_LOGOUT_API];
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]]
                          forHTTPHeaderField:_RECORD_LOGOUT_PARAMETER_KEY];
    
    [self.manager POST:urlString
            parameters:nil
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   [self delectUserInfoToken];
                   [[GIDSignIn sharedInstance] signOut];
                   [self.manager.requestSerializer clearAuthorizationHeader];
                   
                   [[NSUserDefaults standardUserDefaults] setValue:nil forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
                   [[NSUserDefaults standardUserDefaults] setObject:nil forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:nil forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
                   [[NSUserDefaults standardUserDefaults] setObject:nil forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
                   
                   complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self.manager.requestSerializer clearAuthorizationHeader];
                   
                   complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
               }];
    
}



#pragma mark - get or delect token method
/* insert userinfo into UserDefault */
- (void)insertUserInfoWithToken:(NSString *)token {
    
    [self.keyChainWrapperInLoginManager setObject:token forKey:(__bridge id)kSecValueData ];
    self.serverAccessKey = [self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData];
    
}

/* copy and insert token into serverAccessKey of Login Manager  */
- (void)copyUserInfoTokenIntoLoginManager {
    
    self.serverAccessKey = [self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData];
    
}

/* serverAccessKey of Login Manager and UserDefault delete token */
- (void)delectUserInfoToken {
    
    [self.keyChainWrapperInLoginManager resetKeychainItem];
    self.serverAccessKey = nil;
    
}

#pragma mark - change profile
/* change profile image */
- (void)uploadProfileImageWithUIImage:(UIImage *)image
                           complition:(SuccessStateBlock)complition {
    
    NSString *urlString      = [_RECORD_ADDRESS stringByAppendingString:_RECORD_PROFILECHANGE_API];
    NSData *profileImageData = UIImageJPEGRepresentation(image, 0.1f);
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]]
                          forHTTPHeaderField:_RECORD_PROFILECHANGE_PARAMETER_KEY];
    
    [self.manager     POST:urlString
                parameters:nil
 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
     [formData appendPartWithFileData:profileImageData name:@"photo" fileName:@"profile.jpg" mimeType:@"image/jpeg"];
     
 } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
     [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL] forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
     
     [self.manager.requestSerializer clearAuthorizationHeader ];
     
     complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
     
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
     [self.manager.requestSerializer clearAuthorizationHeader ];
     
     complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
     
 }];
    
}

/* change profile personal information */
- (void)uploadProfilePersonalInformationWithNickname:(NSString *)nickname
                                            hometown:(NSString *)hometown
                                    selfIntroduction:(NSString *)introdution
                                          complition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_CHANGE_PROFILE_INFORMATION];
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]]
                          forHTTPHeaderField:_RECORD_PROFILECHANGE_PARAMETER_KEY];
    
    [self.manager     POST:urlString
                parameters:nil
 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
     [formData appendPartWithFormData:[nickname dataUsingEncoding:NSUTF8StringEncoding]
                                 name:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
     [formData appendPartWithFormData:[hometown dataUsingEncoding:NSUTF8StringEncoding]
                                 name:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
     [formData appendPartWithFormData:[introdution dataUsingEncoding:NSUTF8StringEncoding]
                                 name:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
     
 } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
     [[NSUserDefaults standardUserDefaults] setObject:hometown
                                               forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
     [[NSUserDefaults standardUserDefaults] setObject:nickname
                                               forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
     [[NSUserDefaults standardUserDefaults] setObject:introdution
                                               forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
     [self.manager.requestSerializer clearAuthorizationHeader ];
     
     complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
     
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
     [self.manager.requestSerializer clearAuthorizationHeader ];
     complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
     
 }];
}

#pragma mark - valid token check
/* valid token check */
- (void)checkValidTokenWithComplition:(SuccessStateBlock)complition {
    
    NSDictionary *parameters = @{@"key":[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]};

    NSString *urlString      = [_RECORD_ADDRESS stringByAppendingString:_RECORD_CHECK_VALID_TOKEN_API] ;
    
    [self.manager POST:urlString
            parameters:parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   [self copyUserInfoTokenIntoLoginManager];
                   [self.manager.requestSerializer clearAuthorizationHeader];
                   
                   complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                   [self delectUserInfoToken];
                   [self.manager.requestSerializer clearAuthorizationHeader];
                   
                   complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
                   
               }];

}

#pragma mark - insert user infomation with responseObject in userdefault
- (void)insertUserInfoWithResponseObject:(id  _Nullable)responseObject {
    
    [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL]
                                             forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
    [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY]
                                              forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY]
                                              forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:_RECORD_CHANGE_PROFILE_RESPONSEOBJECT_KEY] objectForKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY]
                                              forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
    
}

@end
