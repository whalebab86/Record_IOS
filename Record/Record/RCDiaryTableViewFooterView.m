//
//  RCDiaryTableViewFooterView.m
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryTableViewFooterView.h"

@interface RCDiaryTableViewFooterView ()

@property (weak, nonatomic) IBOutlet UIView *diaryFooterButtonView;

@end

@implementation RCDiaryTableViewFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.diaryFooterButtonView.layer setCornerRadius:2.5];
//    [self.diaryFooterButtonView.layer setBorderWidth:1];
//    [self.diaryFooterButtonView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.diaryFooterButtonView setClipsToBounds:YES];
}

- (IBAction)didClickButton:(UIButton *)sender {
    
    [self.delegate tableViewFooterButton:sender];
}

@end
