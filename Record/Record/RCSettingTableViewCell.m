//
//  RCSettingTableViewCell.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSettingTableViewCell.h"

@implementation RCSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //몰랐던것
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
