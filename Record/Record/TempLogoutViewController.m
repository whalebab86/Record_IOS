//
//  TempLogoutViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 30..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "TempLogoutViewController.h"
#import "RCLoginManager.h"

@interface TempLogoutViewController ()

@end

@implementation TempLogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutaction:(id)sender {
    
    [[RCLoginManager loginManager] facebookLogoutComplition:^(BOOL isSucceess) {
        if (isSucceess) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"currentToken이 nill이 아니다.");
        }
    }];
    
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
