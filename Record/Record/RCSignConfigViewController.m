//
//  RCSignConfigViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSignConfigViewController.h"

@interface RCSignConfigViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *signInContrainer;
@property (weak, nonatomic) IBOutlet UIView *signUpContrainer;


@end

@implementation RCSignConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signInButton.tag = 0;
    self.signUpButton.tag = 1;
    
}
- (IBAction)showSignInContrainer:(UIButton *)sender {
    if (sender.tag == 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.signInContrainer.alpha = 1;
            self.signUpContrainer.alpha = 0;
        }];
    }
}
- (IBAction)showSignUpContrainer:(UIButton *)sender {
    if (sender.tag == 1) {
    
        [UIView animateWithDuration:0.3f animations:^{
            self.signInContrainer.alpha = 0;
            self.signUpContrainer.alpha = 1;
        }];
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
