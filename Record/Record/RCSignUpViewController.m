//
//  RCSignUpViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Google/SignIn.h>
#import "RCSignUpViewController.h"
#import "RCLoginManager.h"
#import "RCMemberValidation.h"

typedef NS_ENUM(NSInteger, texfFieldSelectied) {
    emailTFSelectied = 0,
    passwordTFSelectied,
    confirmPasswordTFSelectied
};

typedef NS_ENUM(NSInteger, selectedButton) {
    selectedCreatAccountBtn = 0,
    selectedFacebookBtn,
    selectedGoogleBtn
};

@interface RCSignUpViewController ()
<UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *signUpMainScroll;
@property (weak, nonatomic) IBOutlet UITextField *signUpEmailTF;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *signUpConfirmPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *signUpCreatAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpFacebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpGoogleBtn;

@end

@implementation RCSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //버튼 코너 둥글게 하는 곳
    self.signUpCreatAccountBtn.layer.cornerRadius = 3.0f;
    self.signUpFacebookBtn.layer.cornerRadius = 3.0f;
    self.signUpGoogleBtn.layer.cornerRadius = 3.0f;
    
    //텍스트필트와 버튼의 tag설정
    self.signUpEmailTF.tag = emailTFSelectied;
    self.signUpPasswordTF.tag = passwordTFSelectied;
    self.signUpConfirmPasswordTF.tag = confirmPasswordTFSelectied;
    self.signUpFacebookBtn.tag = selectedFacebookBtn;
    self.signUpGoogleBtn.tag = selectedGoogleBtn;
    
    //델리게이트 설정
    self.signUpEmailTF.delegate = self;
    self.signUpPasswordTF.delegate = self;
    self.signUpConfirmPasswordTF.delegate = self;
}

#pragma mark - For TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case emailTFSelectied:
            [self.signUpEmailTF resignFirstResponder];
            [self.signUpPasswordTF becomeFirstResponder];
            break;
            
        case passwordTFSelectied:
            [self.signUpPasswordTF resignFirstResponder];
            [self.signUpConfirmPasswordTF becomeFirstResponder];
            break;
            
        case confirmPasswordTFSelectied:
            [self.signUpConfirmPasswordTF resignFirstResponder];
            self.signUpMainScroll.contentOffset = CGPointMake(0, 0);
            break;
        default:
            break;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offsetY = self.signUpConfirmPasswordTF.frame.size.height;
    self.signUpMainScroll.contentOffset = CGPointMake(0, offsetY);
    
    return YES;
}


#pragma mark - For Email account
- (IBAction)signUpCreatAccountButtonAction:(UIButton *)sender {
    if (sender.tag == selectedCreatAccountBtn) {
        BOOL emailValid = YES;
        if (![RCMemberValidation isValidEmail:self.signUpEmailTF.text]) {
            emailValid = NO;
        }
        
        BOOL passwordValid = YES;
        if (![RCMemberValidation isValidPW:self.signUpPasswordTF.text]) {
            passwordValid = NO;
        }
        
        BOOL confirmPassword = YES;
        if (![self.signUpPasswordTF.text isEqualToString:self.signUpConfirmPasswordTF.text]) {
            confirmPassword = NO;
        }
        
        if (!emailValid) {
            [self addAlertViewWithTile:@"Invalid email." actionTitle:@"Done" handler:nil];
        } else if (!passwordValid) {
            [self addAlertViewWithTile:@"At least 8 characters are required. or So easy Password" actionTitle:@"Done" handler:nil];
        } else if (!confirmPassword) {
            [self addAlertViewWithTile:@"Passwords are different." actionTitle:@"Done" handler:nil];
        } else {
            
            //sign up 코드는 백단이 주면 설정
            NSLog(@"로그인 탑니다!");
        }
    }
}

#pragma mark - For Facebook account
- (IBAction)signUpFacebookButtonAction:(UIButton *)sender {
    if (sender.tag == selectedFacebookBtn) {
        [[RCLoginManager loginManager] confirmFacebookLoginfromViewController:self complition:^(BOOL isSucceess) {
            if (isSucceess) {
                NSLog(@"로그인 되었습닌다.");
            }
        }];
    }
}

#pragma mark - For Google account
- (IBAction)signUpGoogleButtonAction:(UIButton *)sender {
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
