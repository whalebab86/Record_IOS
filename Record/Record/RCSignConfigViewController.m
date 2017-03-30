//
//  RCSignConfigViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSignConfigViewController.h"

typedef NS_ENUM(NSInteger, selectedButton) {
    selectedSignInButton =0,
    selectedSingUpButton
};

@interface RCSignConfigViewController ()

@property (weak, nonatomic) IBOutlet UIView *signHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *signInContrainer;
@property (weak, nonatomic) IBOutlet UIView *signUpContrainer;
@property (weak, nonatomic) IBOutlet UIImageView *signMarkImageView;
@property CGPoint offsetCenterSignInBtn;
@property CGPoint offsetCenterSignUpBtn;


@end

@implementation RCSignConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signInButton.tag = selectedSignInButton;
    self.signUpButton.tag = selectedSingUpButton;
    
    self.signInContrainer.alpha = 1;
    self.signUpContrainer.alpha = 0;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat h = self.signHeaderView.frame.size.height + self.signMarkImageView.frame.size.height/2;
    self.offsetCenterSignInBtn = CGPointMake(self.signInButton.center.x, h);
    self.offsetCenterSignUpBtn = CGPointMake(self.signUpButton.center.x, h);
    self.signMarkImageView.center = self.offsetCenterSignInBtn;
}

- (IBAction)showSignInContrainer:(UIButton *)sender {
    if (sender.tag == selectedSignInButton) {
        [UIView animateWithDuration:0.3f animations:^{
            self.signInContrainer.alpha = 1;
            self.signUpContrainer.alpha = 0;
            self.signMarkImageView.center = self.offsetCenterSignInBtn;
            self.signMarkImageView.image = [UIImage imageNamed:@"SignInMark"];
        }];
        [self.view endEditing:YES];
    }
}

- (IBAction)showSignUpContrainer:(UIButton *)sender {
    if (sender.tag == selectedSingUpButton) {
        [UIView animateWithDuration:0.3f animations:^{
            self.signInContrainer.alpha = 0;
            self.signUpContrainer.alpha = 1;
            self.signMarkImageView.center = self.offsetCenterSignUpBtn;
            self.signMarkImageView.image = [UIImage imageNamed:@"SignUpMark"];
        }];
        [self.view endEditing:YES];
    }
}

- (IBAction)endEditingTapGesture:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
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
