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
@property (nonatomic) NSURLSessionDataTask *dataTask;
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
        self.manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
        self.serializer = [AFHTTPRequestSerializer serializer];
        self.keyChainWrapperInLoginManager = [[KeychainItemWrapper alloc] initWithIdentifier:_RECORD_KEYCHAINITEMWRAPPER_KEY accessGroup:nil];
    }
    return self;
}

#pragma mark - upload task modul in sign in and sign up, etc
//- (void)uploadTaskModulWithAPI:(NSString *)api
//            requestMethod:(NSString *)method
//           inputParameter:(NSDictionary *)parameters
//            setStatusCode:(NSArray *)codeArray
//                complition:(SuccessStateBlock)complition {
//    
//    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:api];
//    
//    NSURLRequest *request = [self.serializer requestWithMethod:method
//                                                     URLString:urlString
//                                                    parameters:parameters
//                                                         error:nil];
//    
//    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
//                                                       progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                                                           NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
//                                                           if (error) {
//                                                               NSLog(@"Email login NSError %@  statusCode %ld, responseObject %@", error, httpRespose.statusCode, responseObject);
//                                                               complition(NO, httpRespose.statusCode);
//                                                           } else {
//                                                               if (httpRespose.statusCode == [codeArray[0] integerValue]) {
//                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
//                                                                   NSLog(@"login success");
//                                                                   [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
//                                                                   complition(YES, httpRespose.statusCode);
//                                                               } else if (httpRespose.statusCode == [codeArray[1] integerValue]) {
//                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
//                                                                   complition(NO, httpRespose.statusCode);
//                                                               } else {
//                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
//                                                                   complition(NO, httpRespose.statusCode);
//                                                               }
//                                                           }
//                                                       }];
//    [self.dataTask resume];
//}

#pragma mark - Google Login Method
/* recived user info from google and return status code */
- (void)recivedGoogleUserInfo:(GIDGoogleUser *)user
                    complition:(SuccessStateBlock)complition {
    // For client-side use only!
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:user.profile.email,
                                 _RECORD_SIGNUP_NICKNAME_KEY:@"",
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_GOOGLE};
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
        complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
    }];
    
//    NSLog(@"user.userID %@", user.userID);
//    // Safe to send to the server
//    NSLog(@"user.authentication.idToken %@", user.authentication.idToken);
//    
//    NSLog(@"user.profile.name %@",user.profile.name);
//    
//    NSLog(@"user.profile.givenName %@", user.profile.givenName);
//    
//    NSLog(@"user.profile.familyName %@", user.profile.familyName);
//    
//    NSLog(@"user.profile.email %@", user.profile.email);
    
}

#pragma mark - Facebook Login Logout Method
/* facebook login */
- (void)confirmFacebookLoginfromViewController:(UIViewController *)fromViewController
                                    complition:(SuccessStateBlock)complition {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"FBSDKAccessToken currentAccessToken");
        [self dispatchUserInfoFormFacebook:complition];
        
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"email"]
         fromViewController:fromViewController
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
                 complition(NO, error.code);
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
                 complition(NO, error.code);
             } else {
                 NSLog(@"Logged in");
                 [self dispatchUserInfoFormFacebook:complition];
             }
         }];
    }
}

/* facebook logout */
- (void)facebookLogout {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logOut];
    
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        NSLog(@"facebook log out success");
    }
}

/*  */
-(void)dispatchUserInfoFormFacebook:(SuccessStateBlock)complition {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(result)
        {
            
//            [FBSDKAccessToken currentAccessToken].userID
            NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:[result objectForKey:@"email"],
                                         _RECORD_SIGNUP_NICKNAME_KEY:[result objectForKey:@"name"],
                                         _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_FACEBOOK};
            
            NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
            [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
            }];
//
//            if ([result objectForKey:@"name"]) {
//                NSLog(@"First Name : %@",[result objectForKey:@"name"]);
//            }
//            if ([result objectForKey:@"id"]) {
//                NSLog(@"User id : %@",[result objectForKey:@"id"]);
//            }
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
                                 @"password":password};
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNIN_API];
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
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
    
    NSDictionary *parameters =@{_RECORD_SIGNUP_NAME_KEY:email,
                                _RECORD_SIGNUP_PASSWORD_KEY:password,
                                _RECORD_SIGNUP_NICKNAME_KEY:nickName,
                                _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_NORMAL};
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
        complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
    }];
}


#pragma mark - logout method

- (void)logoutWithComplition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_LOGOUT_API];
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]] forHTTPHeaderField:_RECORD_LOGOUT_PARAMETER_KEY];
    [self.manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self delectUserInfoToken];
        complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
- (void)uploadProfileImageWithUIImage:(UIImage *)image complition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_PROFILECHANGE_API];
    NSData *profileImageData = UIImageJPEGRepresentation(image, 0.1f);
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]] forHTTPHeaderField:_RECORD_PROFILECHANGE_PARAMETER_KEY];
   
    [self.manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:profileImageData name:@"photo" fileName:@"profile.jpg" mimeType:@"image/jpeg"];
//        [formData appendPartWithFormData:<#(nonnull NSData *)#> name:<#(nonnull NSString *)#>];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.profileImageURL = [[responseObject objectForKey:@"user"] objectForKey:@"profile_img"];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"user"] objectForKey:_RECORD_CHANGE_PROFILE_IMAGE_URL] forKey:_RECORD_CHANGE_PROFILE_IMAGE_URL];
        complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
    }];

}

/* change profile personal information */
- (void)uploadProfilePersonalInformationWithNickname:(NSString *)nickname hometown:(NSString *)hometown selfIntroduction:( NSString *)introdution complition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_CHANGE_PROFILE_INFORMATION];
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.manager.requestSerializer setValue:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]] forHTTPHeaderField:_RECORD_PROFILECHANGE_PARAMETER_KEY];
   
    NSDictionary *parameters =@{_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY:hometown, _RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY:nickname, _RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY:introdution};
    
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:hometown forKey:_RECORD_CHANGE_PROFILE_INFORMATION_HOMETOWN_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:_RECORD_CHANGE_PROFILE_INFORMATION_NICKNAME_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:introdution forKey:_RECORD_CHANGE_PROFILE_INFORMATION_INTRODUCTION_KEY];
        complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
    }];
}


#pragma mark - valid token check
/* valid token check */
- (void)checkValidTokenWithComplition:(SuccessStateBlock)complition {
    
    NSDictionary *parameters =@{@"key":[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]};

    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_CHECK_VALID_TOKEN_API];
    
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self copyUserInfoTokenIntoLoginManager];
        complition(YES, ((NSHTTPURLResponse *)task.response).statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self delectUserInfoToken];
        complition(NO, ((NSHTTPURLResponse *)task.response).statusCode);
    }];

}



@end
