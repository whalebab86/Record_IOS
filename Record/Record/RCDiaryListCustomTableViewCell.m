//
//  RCDiaryListCustomTableViewCell.m
//  Record
//
//  Created by CLAY on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryListCustomTableViewCell.h"

@interface RCDiaryListCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView      *diaryAccessoryView;

@end

@implementation RCDiaryListCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    /* Accessory View Custom */
//    [self.diaryAccessoryView.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.diaryAccessoryView.layer setBorderWidth:1];
//    [self.diaryAccessoryView.layer setCornerRadius:(self.diaryAccessoryView.frame.size.height/2.0f)];
//    [self.diaryAccessoryView       setClipsToBounds:YES];
    
    /* Diary Image View Custom */
    [self.diaryMainImageView.layer setCornerRadius:5];
    [self.diaryMainImageView       setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
