//
//  RCSplashViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSplashViewController.h"

@interface RCSplashViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation RCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //로그인 페이지 이동 버튼의 레이어와 색 설정
    [self setBtnLayerAndColor:self.signUpBtn];
    
    //회원가입 페이지 이동 버튼의 레이어와 색 설정
    [self setBtnLayerAndColor:self.signInBtn];

}



- (void)setBtnLayerAndColor:(UIButton *)customBtn {
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customBtn.layer.borderWidth = 1.0f;
    customBtn.layer.cornerRadius = 3.0f;
    customBtn.layer.borderColor = [UIColor colorWithRed:106/255.0f green:108/255.0f blue:114/255.0f alpha:1.0f].CGColor;
    customBtn.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.1f];
    
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
