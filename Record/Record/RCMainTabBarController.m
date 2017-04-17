//
//  RCMainTabBarController.m
//  Record
//
//  Created by CLAY on 2017. 4. 12..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMainTabBarController.h"

#import "RCLoginManager.h"

@interface RCMainTabBarController ()

@end

@implementation RCMainTabBarController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    [[RCLoginManager loginManager] checkValidTokenWithComplition:^(BOOL isSucceess, NSInteger code) {
        if(!isSucceess) {
            [self performSegueWithIdentifier:@"RecordLoginSegue" sender:self];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
