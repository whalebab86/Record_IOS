//
//  RCLoginManager.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <AFNetworking.h>
#import "RCLoginManager.h"

@interface RCLoginManager()
<GIDSignInUIDelegate, GIDSignInUIDelegate>

@property (nonatomic) NSURLSessionDataTask *dataTask;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) AFHTTPSessionManager *manager;

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
    }
    return self;
}

#pragma mark - Google Login Logout Method
- (void)recivedGoogleUserInfo:(GIDGoogleUser *)user
                    complition:(LoginSuccessBlock)complition {
    // For client-side use only!
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:user.profile.email,
                                 _RECORD_SIGNUP_NICKNAME_KEY:user.profile.name,
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_GOOGLE};
    
    NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                     URLString:urlString
                                                    parameters:parameters
                                                         error:nil];
    
    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                                                       progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                                                           if (error) {
                                                               NSLog(@"Email login NSError %@", error);
                                                               complition(NO, httpRespose.statusCode);
                                                           } else {
                                                               if (httpRespose.statusCode == 201) {
                                                                   NSLog(@"Code == 201 %@", responseObject);
                                                                   complition(YES, httpRespose.statusCode);
                                                               } else if (httpRespose.statusCode == 400) {
                                                                   NSLog(@"Code == 400 responseObject %@", responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               } else {
                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               }
                                                           }
                                                       }];
    [self.dataTask resume];
    
    
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
- (void)confirmFacebookLoginfromViewController:(UIViewController *)fromViewController
                                    complition:(LoginSuccessBlock)complition {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"FBSDKAccessToken currentAccessToken");
        [self dispatchUserInfo:complition];
        
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
                 [self dispatchUserInfo:complition];
             }
         }];
    }
}

- (void)facebookLogout {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logOut];
    
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        NSLog(@"facebook log out success");
    }
}

-(void)dispatchUserInfo:(LoginSuccessBlock)complition {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(result)
        {
            
            NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
            NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:[FBSDKAccessToken currentAccessToken].userID,
                                         _RECORD_SIGNUP_NICKNAME_KEY:[result objectForKey:@"name"],
                                         _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_FACEBOOK};
            
            NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                             URLString:urlString
                                                            parameters:parameters
                                                                 error:nil];
            
            self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                                                               progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                   NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                                                                   if (error) {
                                                                       NSLog(@"Email login NSError %@", error);
                                                                       complition(NO, httpRespose.statusCode);
                                                                   } else {
                                                                       
                                                                       if (httpRespose.statusCode == 201) {
                                                                           NSLog(@"Code == 201 %@", responseObject);
                                                                           complition(YES, httpRespose.statusCode);
                                                                       } else if (httpRespose.statusCode == 400) {
                                                                           NSLog(@"Code == 400 responseObject %@", responseObject);
                                                                           complition(NO, httpRespose.statusCode);
                                                                       } else {
                                                                           NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                           complition(NO, httpRespose.statusCode);
                                                                       }
                                                                   }
                                                               }];
            [self.dataTask resume];
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
    
//    UITextView
}

#pragma mark - Email Login Logout Method
/* const 는 서버에서 api 주면 시작 */
- (void)localEmailPasswordInputEmail:(NSString *)email
                         inputPassword:(NSString *)password
                    isSucessComplition:(LoginSuccessBlock)complition
{
    NSString *urlString = [@"https://fc-ios.lhy.kr/api" stringByAppendingString:@"/member/login/"];
    NSDictionary *parameters = @{@"username":email,
                                 @"password":password};
    
    NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];

    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                     progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                         if (error) {
                             NSLog(@"Email login NSError %@", error);
                             complition(NO, 0);
                         } else {
                             NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                             if (httpRespose.statusCode == 200) {
                                 NSLog(@"Code == 200 %@", responseObject);
                                 complition(YES, 0);
                             } else if (httpRespose.statusCode == 400) {
                                 NSLog(@"Code == 400 responseObject %@", responseObject);
                                 complition(NO, 0);
                             }
                         }
                     }];
    [self.dataTask resume];
}

#pragma mark - Eamil Sign up Method

- (void)localSignupInputEmail:(NSString *)email
                inputPassword:(NSString *)password
                inputNickName:(NSString *)nickName
                   complition:(LoginSuccessBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_SIGNUP_API];
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:email,
                                 _RECORD_SIGNUP_PASSWORD_KEY:password,
                                 _RECORD_SIGNUP_NICKNAME_KEY:nickName,
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_NORMAL};
    
    NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                     URLString:urlString
                                                    parameters:parameters
                                                         error:nil];
    
    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                                                       progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                                                           if (error) {
                                                               NSLog(@"Email login NSError %@", error);
                                                               complition(NO, httpRespose.statusCode);
                                                           } else {
                                                               
                                                               if (httpRespose.statusCode == 201) {
                                                                   NSLog(@"Code == 201 %@", responseObject);
                                                                   complition(YES, httpRespose.statusCode);
                                                               } else if (httpRespose.statusCode == 400) {
                                                                   NSLog(@"Code == 400 responseObject %@", responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               } else {
                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               }
                                                           }
                                                       }];
    [self.dataTask resume];
    
    
}






@end
