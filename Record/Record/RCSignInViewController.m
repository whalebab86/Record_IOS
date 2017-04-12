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
#import "RCUtilyValidation.h"

#import "RCSignConfigViewController.h"

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
    
    /* button cornerRadius */
    self.signInLoginBtn.layer.cornerRadius = 3.0f;
    self.signInLoginFacebook.layer.cornerRadius = 3.0f;
    self.signInLoginGoogle.layer.cornerRadius = 3.0f;
    
    /* textfield delegate */
    self.signInEmailTF.delegate = self;
    self.signInPasswordTF.delegate = self;
    
    /* google signin delegate */
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate= self;
    
    /* text field place holder color change */
    self.signInEmailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.signInEmailTF.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:197/255.0 green:208/255.0 blue:222/255.0 alpha:1.0f] }];
    self.signInPasswordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.signInPasswordTF.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:197/255.0 green:208/255.0 blue:222/255.0 alpha:1.0f] }];
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.signInEmailTF) {
        [self.signInEmailTF resignFirstResponder];
        [self.signInPasswordTF becomeFirstResponder];
    } else if (textField == self.signInPasswordTF) {
        [self.signInPasswordTF resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Email login
- (IBAction)emailLoginButtonAction:(UIButton *)sender {
    
    __weak RCSignInViewController *signInVC = self;
    
    if (sender == self.signInLoginBtn) {
        if (![RCUtilyValidation isValidEmail:self.signInEmailTF.text]) {
            [self addAlertViewWithTile:@"유효한 Email이 아닙니다" actionTitle:@"확인" handler:^(UIAlertAction *action) {
                signInVC.signInEmailTF.text = @"";
                signInVC.signInPasswordTF.text = @"";
            }];
            
        } else {
            [[RCLoginManager loginManager] localEmailPasswordInputEmail:self.signInEmailTF.text inputPassword:self.signInPasswordTF.text isSucessComplition:^(BOOL isSucceess, NSInteger code) {
                if (isSucceess) {
                    NSLog(@"login success");
                    [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignin" sender:nil];
                    
                } else {
                    NSLog(@"login fail");
                    [self addAlertViewWithTile:@"로그인에 실패하였습니다." actionTitle:@"확인" handler:^(UIAlertAction *action) {
                        signInVC.signInEmailTF.text = @"";
                        signInVC.signInPasswordTF.text = @"";
                    }];
                }
            }];
        }
    }
}

#pragma mark - For facebook login
/* facebook login button action */
- (IBAction)facebookLoginButtonAction:(UIButton *)sender {
    if (sender == self.signInLoginFacebook) {
        [[RCLoginManager loginManager] confirmFacebookLoginfromViewController:self complition:^(BOOL isSucceess, NSInteger code) {
            if (isSucceess) {
//                [self performSegueWithIdentifier:@"OtherSegue" sender:nil];
                [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignin" sender:nil];
            } else {
                NSString *alertTitle = [@"facebook login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
                [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
            }
        }];
    }
}

#pragma mark - For Google login
/* google login button action */
- (IBAction)googleLoginButtonAction:(UIButton *)sender {
    if (sender == self.signInLoginGoogle) {
        [[GIDSignIn sharedInstance] signIn];
    }
}

/* google sign-in flow has finished and was successful if |error| is |nil|. */
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    [[RCLoginManager loginManager] recivedGoogleUserInfo:user complition:^(BOOL isSucceess, NSInteger code) {
        if (isSucceess) {
            NSLog(@"googleSuccess");
            [self performSegueWithIdentifier:@"ProfileSettingSegueFromSignin" sender:nil];
        } else {
            NSString *alertTitle = [@"google login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
            [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
        }
    }];
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
