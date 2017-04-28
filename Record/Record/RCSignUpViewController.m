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
#import "RCUtilyValidation.h"


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
    
    /* button delegate */
    self.signUpCreatAccountBtn.layer.cornerRadius = 3.0f;
    self.signUpFacebookBtn.layer.cornerRadius = 3.0f;
    self.signUpGoogleBtn.layer.cornerRadius = 3.0f;
    
    /* textfield delegate */
    self.signUpEmailTF.delegate = self;
    self.signUpPasswordTF.delegate = self;
    self.signUpConfirmPasswordTF.delegate = self;
    
    /* google sign in delegate */
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate= self;
    
    /* text field place holder color change */
    self.signUpEmailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.signUpEmailTF.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:197/255.0 green:208/255.0 blue:222/255.0 alpha:1.0f] }];
    self.signUpPasswordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.signUpPasswordTF.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:197/255.0 green:208/255.0 blue:222/255.0 alpha:1.0f] }];
    self.signUpConfirmPasswordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.signUpConfirmPasswordTF.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:197/255.0 green:208/255.0 blue:222/255.0 alpha:1.0f] }];
    
    
    
    
}

#pragma mark - TextField delegate
/* textfield should return */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.signUpEmailTF) {
        [self.signUpEmailTF resignFirstResponder];
        [self.signUpPasswordTF becomeFirstResponder];
    } else if (textField == self.signUpPasswordTF) {
        [self.signUpPasswordTF resignFirstResponder];
        [self.signUpConfirmPasswordTF becomeFirstResponder];
    } else if (textField == self.signUpConfirmPasswordTF) {
        [self.signUpConfirmPasswordTF resignFirstResponder];
        self.signUpMainScroll.contentOffset = CGPointMake(0, 0);
    } else {
        NSLog(@"다른 텍스트 필드가 연동중 확인 필요");
    }
    
    return YES;
}

/* textfield should begin */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offsetY = self.signUpConfirmPasswordTF.frame.size.height;
    self.signUpMainScroll.contentOffset = CGPointMake(0, offsetY);
    
    return YES;
}

#pragma mark - For Email account
/* */
- (IBAction)signUpCreatAccountButtonAction:(UIButton *)sender {
    if (sender == self.signUpCreatAccountBtn) {
        BOOL emailValid = YES;
        if (![RCUtilyValidation isValidEmail:self.signUpEmailTF.text]) {
            emailValid = NO;
        }
        
        BOOL passwordValid = YES;
        if (![RCUtilyValidation isValidPW:self.signUpPasswordTF.text]) {
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
            
            
            [[RCLoginManager loginManager] localSignupInputEmail:self.signUpEmailTF.text inputPassword:self.signUpPasswordTF.text inputNickName:@"" complition:^(BOOL isSucceess, NSInteger code) {
              
                if (isSucceess) {
                    
                        NSLog(@"로그인 탑니다!");
                        [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignup" sender:nil];
                    
                } else {
                    
                    NSLog(@"%ld", code);
                    [self addAlertViewWithTile:[NSString stringWithFormat:@"회원가입에 실패하였습니다. %ld", code] actionTitle:@"확인" handler:nil];
                }
                
            }];
            
        }
    }
}

#pragma mark - For Facebook account
/* facebook sign up */
- (IBAction)signUpFacebookButtonAction:(UIButton *)sender {
    if (sender == self.signUpFacebookBtn) {
        [[RCLoginManager loginManager] confirmFacebookSignupfromViewController:self complition:^(BOOL isSucceess, NSInteger code) {
            if (isSucceess) {
                NSLog(@"로그인 되었습닌다.");
                [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignin" sender:nil];
            } else {
                NSLog(@"%ld", code);
                [self addAlertViewWithTile:[NSString stringWithFormat:@"회원가입에 실패하였습니다. %ld", code] actionTitle:@"확인" handler:nil];
            }
        }];
    }
}

#pragma mark - For Google account
/* google sign up */
- (IBAction)signUpGoogleButtonAction:(UIButton *)sender {
    if (sender == self.signUpGoogleBtn) {
        [[GIDSignIn sharedInstance] signIn];
    }
}

/* google sign-in flow has finished and was successful if |error| is |nil|. */
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

        [[RCLoginManager loginManager] recivedForGoogleSignupUserInfo:user complition:^(BOOL isSucceess, NSInteger code) {
        if (isSucceess) {
            [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignup" sender:nil];
        } else if (code == 400) {
            
            [[RCLoginManager loginManager] recivedForGoogleLoginWithUserInfo:user complition:^(BOOL isSucceess, NSInteger code) {
                if (isSucceess) {
                    [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignup" sender:nil];
                } else {
                    NSString *alertTitle = [@"google login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
                    [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
                }
            }];
        }
        else {
            NSString *alertTitle = [@"google login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
            [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
        }
    }];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {

}

/**
 * google sign-in flow has finished selecting how to proceed, and the UI should no longer display a spinner or other "please wait" element.
 */
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //    NSLog(@"signInWillDispatch signIn %@", signIn);
    
}

#pragma mark - alert method
- (void)addAlertViewWithTile:(nullable NSString *)viewTitle actionTitle:(nullable NSString *)actionTitle handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:viewTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertView addAction:done];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - RCSignUpViewController Delegate

- (void)resetOffset {
    self.signUpMainScroll.contentOffset = CGPointMake(0, 0);
}

#pragma mark - etc
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
