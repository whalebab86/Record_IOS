//
//  RCSignConfigViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSignConfigViewController.h"
#import "RCSignUpViewController.h"

@interface RCSignConfigViewController ()

@property (weak, nonatomic) IBOutlet UIView *signHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *signInContrainer;
@property (weak, nonatomic) IBOutlet UIView *signUpContrainer;
@property (weak, nonatomic) IBOutlet UIImageView *signMarkImageView;
@property CGPoint offsetCenterSignInBtn;
@property CGPoint offsetCenterSignUpBtn;

@property RCSignUpViewController *signUpViewContollerForSegue;

@end

@implementation RCSignConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* Default alpha of signin contrainer */
    self.signInContrainer.alpha = 1;
    self.signUpContrainer.alpha = 0;
}

#pragma mark - Transition of reverse triangle UIImageView
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    /* Default setting center offset of reverse triangle mark  */
    CGFloat markOffsetCenterY = self.signHeaderView.frame.size.height + self.signMarkImageView.frame.size.height/2;
    self.offsetCenterSignInBtn = CGPointMake(self.signInButton.center.x, markOffsetCenterY);
    self.offsetCenterSignUpBtn = CGPointMake(self.signUpButton.center.x, markOffsetCenterY);
    self.signMarkImageView.center = self.offsetCenterSignInBtn;
    
    
}

#pragma mark - Switching Contrainer View
/* Show signInContrainer view at signInButton */
- (IBAction)showSignInContrainer:(UIButton *)sender {
    if (sender == self.signInButton) {
        [UIView animateWithDuration:0.3f animations:^{
            self.signInContrainer.alpha = 1;
            self.signUpContrainer.alpha = 0;
            self.signMarkImageView.center = self.offsetCenterSignInBtn;
            self.signMarkImageView.image = [UIImage imageNamed:@"SignInMark"];
        }];
        [self.view endEditing:YES];
    }
    
    
}

/* Show signUpContrainer view at signUpButton */
- (IBAction)showSignUpContrainer:(UIButton *)sender {
    if (sender == self.signUpButton) {
        [UIView animateWithDuration:0.3f animations:^{
            self.signInContrainer.alpha = 0;
            self.signUpContrainer.alpha = 1;
            self.signMarkImageView.center = self.offsetCenterSignUpBtn;
            self.signMarkImageView.image = [UIImage imageNamed:@"SignUpMark"];
        }];
        
        [self.signUpViewContollerForSegue resetOffset];
        [self.view endEditing:YES];
    }
}


#pragma mark - TapGesture
/* resignFirstResponder by tap gesture */
- (IBAction)endEditingTapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - etc
/* This method is existent for signup scrollView contentOffset */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RCSignUpViewSegue"]) {
        self.signUpViewContollerForSegue = [segue destinationViewController];
    }
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
