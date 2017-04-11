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

@interface RCSplashViewController ()
<GIDSignInDelegate, GIDSignInUIDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation RCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    /* Signin button change layer and layer color */
    self.signInBtn.layer.borderWidth = 1.0f;
    self.signInBtn.layer.cornerRadius = 3.0f;
    self.signInBtn.layer.borderColor = [UIColor colorWithRed:106/255.0f green:108/255.0f blue:114/255.0f alpha:1.0f].CGColor;
    
    /* facebook button cornerRadius */
    self.facebookBtn.layer.cornerRadius = 3.0f;
    
    /* google button cornerRadius */
    self.googleBtn.layer.cornerRadius = 3.0f;
    
    /* google sign in delegate */
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate= self;
    
    /* scroll view */
    self.mainScrollView.delegate = self;
}
#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == 0) {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.contentSize.width/2, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) animated:YES];
    } else if (scrollView.contentOffset.x == scrollView.contentSize.width) {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) animated:YES];
    }
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat currentOffsetX = scrollView.contentOffset.x;
//    CGFloat currentOffSetY = scrollView.contentOffset.y;
//    CGFloat contentWidth = scrollView.contentSize.width;
//    
//    if (currentOffsetX < -20) {
//        //(contentWidth / 6.0f)
//        [UIView animateWithDuration:0.3f animations:^{
//            scrollView.contentOffset = CGPointMake(contentWidth/2, currentOffSetY);
//        }];
//        
////        NSLog(@"currentOffsetX == %lf < (contentWidth / 6.0f) == %lf", currentOffsetX ,  contentWidth / 6.0f);
////        NSLog(@"currentOffsetX %lf , scrollView.contentOffset %lf",currentOffsetX,  currentOffsetX + contentWidth/2);
//    }
//    if (currentOffsetX > contentWidth/2 + 20) {
//        [UIView animateWithDuration:0.3f animations:^{
//            scrollView.contentOffset = CGPointMake(0, currentOffSetY);
//        }];
//        
////        NSLog(@"currentOffsetX == %lf > (contentWidth*4/ 6.0f) == %lf", currentOffsetX ,  contentWidth*4/ 6.0f);
////        NSLog(@"currentOffsetX %lf , scrollView.contentOffset %lf",currentOffsetX,  currentOffsetX - contentWidth/2);
//    }
//    
//}


#pragma mark - Create account with Facebook
/* create account with facebook */
- (IBAction)facebookLoginButtonAction:(UIButton *)sender {
    
    if(sender == self.facebookBtn) {
        NSLog(@"facebookLoginButtonAction");
        [[RCLoginManager loginManager] confirmFacebookLoginfromViewController:self complition:^(BOOL isSucceess, NSInteger code) {
            if (isSucceess) {
                [self performSegueWithIdentifier:@"SettingSegueFromSplash" sender:nil];
                NSLog(@"confirmFacebookLoginfromViewController");
            } else {
                NSString *alertTitle = [@"facebook login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
                [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
            }
        }];
    }
}

#pragma mark - Create account with Google
/* create account with google */
- (IBAction)googleLoginButtonAction:(UIButton *)sender {
    if (sender == self.googleBtn) {
        [[GIDSignIn sharedInstance] signIn];
    }
}


/**
 *로그인 이후 뷰컨트롤러 연결은 다음 setting page 이후 만들것임.
 */
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    NSLog(@"signInWillDispatch signIn %@", signIn);
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    [[RCLoginManager loginManager] recivedGoogleUserInfo:user complition:^(BOOL isSucceess, NSInteger code) {
        if (isSucceess) {
            NSLog(@"googleSuccess");
            [self performSegueWithIdentifier:@"SettingSegueFromSplash" sender:nil];
        } else {
            NSString *alertTitle = [@"google login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
            [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
        }
    }];
    
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
