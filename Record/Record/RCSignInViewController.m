//
//  RCSignInViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSignInViewController.h"

typedef NS_ENUM(NSInteger, texfFieldSelectied) {
    
    emailTFSelectied = 0,
    passwordTFSelectied
    
};

@interface RCSignInViewController ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *signInEmailTF;
@property (weak, nonatomic) IBOutlet UITextField *signInPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *signInLoginBtn;

@end

@implementation RCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signInLoginBtn.layer.cornerRadius = 3.0f;

    self.signInEmailTF.tag = emailTFSelectied;
    self.signInPasswordTF.tag = passwordTFSelectied;
    
    self.signInEmailTF.delegate = self;
    self.signInPasswordTF.delegate = self;
    
}




- (IBAction)loginBtnAction:(id)sender {
    
    NSLog(@"로그인 버튼이 눌렸습니다.");
    
}

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
