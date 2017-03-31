//
//  RCSignInViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Google/SignIn.h>
#import "RCSignInViewController.h"
#import "RCLoginManager.h"
#import "RCMemberValidation.h"

typedef NS_ENUM(NSInteger, texfFieldSelected) {
    emailTFSelectied = 0,
    passwordTFSelectied
};
typedef NS_ENUM(NSInteger, selectedBtn) {
    selectedLoginBtn = 0,
    selectedFacebookBtn,
    selectedGoogleBtn
};

@interface RCSignInViewController ()
<UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UITextField *signInEmailTF;
@property (weak, nonatomic) IBOutlet UITextField *signInPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *signInLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInLoginFacebook;
@property (weak, nonatomic) IBOutlet UIButton *signInLoginGoogle;

@end

@implementation RCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //버튼 코너 둥글게 하는 곳
    self.signInLoginBtn.layer.cornerRadius = 3.0f;
    self.signInLoginFacebook.layer.cornerRadius = 3.0f;
    self.signInLoginGoogle.layer.cornerRadius = 3.0f;
    
    //텍스트필트와 버튼의 tag설정
    self.signInEmailTF.tag = emailTFSelectied;
    self.signInPasswordTF.tag = passwordTFSelectied;
    self.signInLoginBtn.tag = selectedLoginBtn;
    self.signInLoginFacebook.tag = selectedFacebookBtn;
    self.signInLoginGoogle.tag = selectedGoogleBtn;
    
    //델리게이트 설정
    self.signInEmailTF.delegate = self;
    self.signInPasswordTF.delegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate= self;
}

#pragma mark - For TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case emailTFSelectied:
            [self.signInEmailTF resignFirstResponder];
            [self.signInPasswordTF becomeFirstResponder];
            break;
            
        case passwordTFSelectied:
            [self.signInPasswordTF resignFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}


#pragma mark - For Email login
- (IBAction)emailLoginButtonAction:(UIButton *)sender {
    
    
    __weak RCSignInViewController *vc = self;
    
    if (sender.tag == selectedLoginBtn) {
        if (![RCMemberValidation isValidEmail:self.signInEmailTF.text]) {
            [self addAlertViewWithTile:@"유효한 Email이 아닙니다" actionTitle:@"확인" handler:^(UIAlertAction *action) {
                vc.signInEmailTF.text = @"";
                vc.signInPasswordTF.text = @"";
            }];
            
        } else {
            [[RCLoginManager loginManager] localEmailPasswordInputEmail:self.signInEmailTF.text inputPassword:self.signInPasswordTF.text isSucessComplition:^(BOOL isSucceess) {
                if (isSucceess) {
                    NSLog(@"login success");
                } else {
                    NSLog(@"login fail");
                    [self addAlertViewWithTile:@"로그인에 실패하였습니다." actionTitle:@"확인" handler:^(UIAlertAction *action) {
                        vc.signInEmailTF.text = @"";
                        vc.signInPasswordTF.text = @"";
                    }];
                }
            }];
        }
    }
}

#pragma mark - For facebook login
- (IBAction)facebookLoginButtonAction:(UIButton *)sender {
    if (sender.tag == selectedFacebookBtn) {
        [[RCLoginManager loginManager] confirmFacebookLoginfromViewController:self complition:^(BOOL isSucceess) {
            if (isSucceess) {
                NSLog(@"로그인 되었습닌다.");
            }
        }];
    }
}

#pragma mark - For Google login
- (IBAction)googleLoginButtonAction:(UIButton *)sender {
    if (sender.tag == selectedGoogleBtn) {
        [[GIDSignIn sharedInstance] signIn];
    }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    [[RCLoginManager loginManager] recivedGoogleUserInfo:user];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //    NSLog(@"signInWillDispatch signIn %@", signIn);
    
}

- (void)addAlertViewWithTile:(nullable NSString *)viewTitle actionTitle:(nullable NSString *)actionTitle handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:viewTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertView addAction:done];
    [self presentViewController:alertView animated:YES completion:nil];
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
