//
//  RCSupportViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 4..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSupportViewController.h"
#import "RCSettingTableInfo.h"

@interface RCSupportViewController ()

@end

@implementation RCSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (IBAction)connetRecordProjectGitAction:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/whalebab86/Record_IOS"] options:@{} completionHandler:nil];
    
}


- (IBAction)teamMemberYunseoConnetGitButtonAction:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/KimYunseo"] options:@{} completionHandler:nil];
    
}

- (IBAction)teamMemberBongkiConnetGitButtonAction:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/whalebab86"] options:@{} completionHandler:nil];
    
}

- (IBAction)cancelBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
