//
//  RCDiaryTableViewFooterView.m
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryTableViewFooterView.h"

@implementation RCDiaryTableViewFooterView

- (IBAction)didClickButton:(UIButton *)sender {
    
    [self.delegate tableViewFooterButton:sender];
}

@end
