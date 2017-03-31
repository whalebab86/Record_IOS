//
//  RCSplashViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Google/SignIn.h>
#import "RCSplashViewController.h"
#import "RCLoginManager.h"

typedef NS_ENUM(NSInteger, selectedButton) {
    
    selectedFacebookBtn = 0,
    selectedGoogleBtn
    
};

@interface RCSplashViewController ()
<GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;
//@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@end

@implementation RCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    //회원가입 페이지 이동 버튼의 레이어와 색 설정
    [self setBtnLayerAndColor:self.signInBtn];
    
    self.facebookBtn.tag = selectedFacebookBtn;
    self.googleBtn.tag = selectedGoogleBtn;
    
    self.facebookBtn.layer.cornerRadius = 3.0f;
    self.googleBtn.layer.cornerRadius = 3.0f;
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate= self;
}



- (void)setBtnLayerAndColor:(UIButton *)customBtn {
    customBtn.layer.borderWidth = 1.0f;
    customBtn.layer.cornerRadius = 3.0f;
    customBtn.layer.borderColor = [UIColor colorWithRed:106/255.0f green:108/255.0f blue:114/255.0f alpha:1.0f].CGColor;
}

#pragma mark - Create account with Facebook

- (IBAction)facebookLoginButtonAction:(UIButton *)sender {
    if (sender.tag == selectedFacebookBtn) {
        NSLog(@"facebookLoginButtonAction");
        [[RCLoginManager loginManager] confirmFacebookLoginfromViewController:self complition:^(BOOL isSucceess) {
            if (isSucceess) {
                [self performSegueWithIdentifier:@"OtherSegue" sender:nil];
            }
        }];
    }
}

#pragma mark - Create account with Google
- (IBAction)googleLoginButtonAction:(UIButton *)sender {
    if (sender.tag == selectedGoogleBtn) {
        [[GIDSignIn sharedInstance] signIn];
    }
}


/**
 *로그인 이후 뷰컨트롤러 연결은 다음 setting page 이후 만들것임.
 */
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    NSLog(@"signInWillDispatch signIn %@", signIn);
    
}


//
//
//- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//
//- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    [[RCLoginManager loginManager] recivedGoogleUserInfo:user];
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
