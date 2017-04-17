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
- (void)uploadTaskModulWithAPI:(NSString *)api
            requestMethod:(NSString *)method
           inputParameter:(NSDictionary *)parameters
            setStatusCode:(NSArray *)codeArray
                complition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:api];
    
    NSURLRequest *request = [self.serializer requestWithMethod:method
                                                     URLString:urlString
                                                    parameters:parameters
                                                         error:nil];
    
    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                                                       progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                                                           if (error) {
                                                               NSLog(@"Email login NSError %@  statusCode %ld, responseObject %@", error, httpRespose.statusCode, responseObject);
                                                               complition(NO, httpRespose.statusCode);
                                                           } else {
                                                               if (httpRespose.statusCode == [codeArray[0] integerValue]) {
                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   NSLog(@"login success");
                                                                   [self insertUserInfoWithToken:[responseObject objectForKey:_RECORD_ACCESSTOKEN_KEY]];
                                                                   complition(YES, httpRespose.statusCode);
                                                               } else if (httpRespose.statusCode == [codeArray[1] integerValue]) {
                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               } else {
                                                                   NSLog(@"statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               }
                                                           }
                                                       }];
    [self.dataTask resume];
}

#pragma mark - Google Login Method
/* recived user info from google and return status code */
- (void)recivedGoogleUserInfo:(GIDGoogleUser *)user
                    complition:(SuccessStateBlock)complition {
    // For client-side use only!
    NSDictionary *parameters = @{_RECORD_SIGNUP_NAME_KEY:user.profile.email,
                                 _RECORD_SIGNUP_NICKNAME_KEY:@"",
                                 _RECORD_SIGNUP_USER_TYPE_KEY:_RECORD_SIGNUP_USER_TYPE_GOOGLE};
    [self uploadTaskModulWithAPI:_RECORD_SIGNUP_API requestMethod:_RECORD_REQUEST_METHOD_POST inputParameter:parameters setStatusCode:@[@"201", @"400"] complition:complition];
    
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
            
            [self uploadTaskModulWithAPI:_RECORD_SIGNUP_API requestMethod:_RECORD_REQUEST_METHOD_POST inputParameter:parameters setStatusCode:@[@"201",@"400"] complition:complition];
            
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
/* const 는 서버에서 api 주면 시작 */
- (void)localEmailPasswordInputEmail:(NSString *)email
                         inputPassword:(NSString *)password
                    isSucessComplition:(SuccessStateBlock)complition
{
    NSDictionary *parameters = @{@"username":email,
                                 @"password":password};
    
    [self uploadTaskModulWithAPI:_RECORD_SIGNIN_API requestMethod:_RECORD_REQUEST_METHOD_POST inputParameter:parameters setStatusCode:@[@"200",@"401"] complition:complition];
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
    
    [self uploadTaskModulWithAPI:_RECORD_SIGNUP_API requestMethod:_RECORD_REQUEST_METHOD_POST inputParameter:parameters setStatusCode:@[@"201",@"400"] complition:complition];
    
   }


#pragma mark - logout method

- (void)logoutWithComplition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_LOGOUT_API];
    
    NSDictionary *parameters = @{_RECORD_LOGOUT_PARAMETER_KEY:[@"Token " stringByAppendingString:[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]]};
    
    NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                     URLString:urlString
                                                    parameters:parameters
                                                         error:nil];
    
    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                                                       progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                                                           if (error) {
                                                               NSLog(@"error not nil & Email login NSError %@", error);
                                                               complition(NO, httpRespose.statusCode);
                                                           } else {
                                                               
                                                               if (httpRespose.statusCode == 200) {
                                                                   NSLog(@"error nil & Code == 200 %@", responseObject);
                                                                   [self delectUserInfoToken];
                                                                   complition(YES, httpRespose.statusCode);
                                                               } else if (httpRespose.statusCode == 401) {
                                                                   NSLog(@"error nil & Code == 400 responseObject %@", responseObject);
                                                                   [self delectUserInfoToken];
                                                                   complition(NO, httpRespose.statusCode);
                                                               } else {
                                                                   NSLog(@"error nil & statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   complition(NO, httpRespose.statusCode);
                                                               }
                                                           }
                                                       }];
    [self.dataTask resume];
    
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

- (void)uploadProfileImageWithUIImage:(UIImage *)image complition:(SuccessStateBlock)complition {
    
    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_PROFILECHANGE_API];
    NSDictionary *parameters = @{_RECORD_PROFILECHANGE_PARAMETER_KEY:[@"Token " stringByAppendingString:self.serverAccessKey]};
    
    NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                     URLString:urlString
                                                    parameters:parameters
                                                         error:nil];

    NSData *profileImageData = UIImagePNGRepresentation(image);
    self.dataTask = [self.manager uploadTaskWithRequest:request fromData:profileImageData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
        if (error) {
            NSLog(@"error not nil & Email login NSError %@", error);
            complition(NO, httpRespose.statusCode);
        } else {
            
            if (httpRespose.statusCode == 201) {
                NSLog(@"error nil & Code == 200 %@", responseObject);

                complition(YES, httpRespose.statusCode);
            } else if (httpRespose.statusCode == 400) {
                NSLog(@"error nil & Code == 400 responseObject %@", responseObject);
                complition(NO, httpRespose.statusCode);
            } else {
                NSLog(@"error nil & statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                complition(NO, httpRespose.statusCode);
            }
        }
    }];

    [self.dataTask resume];
}

#pragma mark - valid check token

- (void)checkValidTokenWithComplition:(SuccessStateBlock)complition {
    
    NSDictionary *parameters =@{@"key":[self.keyChainWrapperInLoginManager objectForKey:(__bridge id)kSecValueData]};

    NSString *urlString = [_RECORD_ADDRESS stringByAppendingString:_RECORD_CHECK_VALID_TOKEN_API];
    
    NSURLRequest *request = [self.serializer requestWithMethod:@"POST"
                                                     URLString:urlString
                                                    parameters:parameters
                                                         error:nil];
    
    self.dataTask = [self.manager uploadTaskWithStreamedRequest:request
                                                       progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                           NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
                                                           if (error) {
                                                               NSLog(@"error not nil & Email login NSError %@", error);
                                                               [self delectUserInfoToken];
                                                               complition(NO, httpRespose.statusCode);
                                                           } else {
                                                               
                                                               if (httpRespose.statusCode == 200) {
                                                                   NSLog(@"error nil & Code == 200 %@", responseObject);
                                                                   [self copyUserInfoTokenIntoLoginManager];
                                                                   complition(YES, httpRespose.statusCode);
                                                               } else if (httpRespose.statusCode == 401) {
                                                                   NSLog(@"error nil & Code == 400 responseObject %@", responseObject);
                                                                   [self delectUserInfoToken];
                                                                   complition(NO, httpRespose.statusCode);
                                                               } else {
                                                                   NSLog(@"error nil & statusCode %ld, responseObject %@", httpRespose.statusCode, responseObject);
                                                                   [self delectUserInfoToken];
                                                                   complition(NO, httpRespose.statusCode);
                                                               }
                                                           }
                                                       }];
    [self.dataTask resume];
}


@end
