//
//  RCSignUpViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSignUpViewController.h"

typedef NS_ENUM(NSInteger, texfFieldSelectied) {
    
    emailTFSelectied = 0,
    passwordTFSelectied,
    confirmPasswordTFSelectied
};

@interface RCSignUpViewController ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *signUpMainScroll;
@property (weak, nonatomic) IBOutlet UITextField *signUpEmailTF;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *signUpConfirmPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *signUpCreatAccountBtn;

@end

@implementation RCSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signUpCreatAccountBtn.layer.cornerRadius = 3.0f;
    
    self.signUpEmailTF.tag = emailTFSelectied;
    self.signUpPasswordTF.tag = passwordTFSelectied;
    self.signUpConfirmPasswordTF.tag = confirmPasswordTFSelectied;
    
    self.signUpEmailTF.delegate = self;
    self.signUpPasswordTF.delegate = self;
    self.signUpConfirmPasswordTF.delegate = self;
}


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
