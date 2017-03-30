//
//  RCSplashViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSplashViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>

@interface RCSplashViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;

@end

@implementation RCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //회원가입 페이지 이동 버튼의 레이어와 색 설정
    [self setBtnLayerAndColor:self.signInBtn];
    
    self.facebookBtn.layer.cornerRadius = 3.0f;
    
}



- (void)setBtnLayerAndColor:(UIButton *)customBtn {
    customBtn.layer.borderWidth = 1.0f;
    customBtn.layer.cornerRadius = 3.0f;
    customBtn.layer.borderColor = [UIColor colorWithRed:106/255.0f green:108/255.0f blue:114/255.0f alpha:1.0f].CGColor;
}

- (IBAction)facebookLoginButtonAction:(UIButton *)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
        
        [self performSegueWithIdentifier:@"OtherSegue" sender:self];
        NSLog(@"performSegueWithIdentifier");
        [self fetchUserInfo];
        
        
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 [self fetchUserInfo];
             }
         }];
    }
}

-(void)fetchUserInfo
{
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            if ([result objectForKey:@"email"]) {
                NSLog(@"Email: %@",[result objectForKey:@"email"]);
            }
            if ([result objectForKey:@"name"]) {
                NSLog(@"First Name : %@",[result objectForKey:@"name"]);
            }
            if ([result objectForKey:@"id"]) {
                NSLog(@"User id : %@",[result objectForKey:@"id"]);
            }
            
        }
        
    }];
    
    [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
