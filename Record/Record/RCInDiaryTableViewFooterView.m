//
//  RCInDiaryTableViewFooter.m
//  Record
//
//  Created by CLAY on 2017. 4. 14..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryTableViewFooterView.h"

@interface RCInDiaryTableViewFooterView ()

@property (weak, nonatomic) IBOutlet UIView *inDiaryAddView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryPlusView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryTripEndView;

@end

@implementation RCInDiaryTableViewFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.inDiaryAddView.layer setCornerRadius:2.5];
    [self.inDiaryAddView setClipsToBounds:YES];
    
    [self.inDiaryPlusView.layer setCornerRadius:self.inDiaryPlusView.frame.size.height/2];
    [self.inDiaryPlusView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.inDiaryPlusView.layer setBorderWidth:1];
    
    [self.inDiaryPlusView setClipsToBounds:YES];
    
    
    [self.inDiaryTripEndView.layer setCornerRadius:self.inDiaryTripEndView.frame.size.height/2];
    [self.inDiaryTripEndView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.inDiaryTripEndView.layer setBorderWidth:1];
    
    [self.inDiaryTripEndView setClipsToBounds:YES];
}

- (IBAction)clickAddInDiaryButton:(UIButton *)sender {
    
    [self.delegate tableViewFooterButton:sender];
}

@end
