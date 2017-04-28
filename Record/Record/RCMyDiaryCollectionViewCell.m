//
//  RCMyDiaryCollectionViewCell.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 13..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMyDiaryCollectionViewCell.h"

@implementation RCMyDiaryCollectionViewCell

-(void)layoutSubviews {
    [super layoutSubviews];
    self.mainImage.layer.cornerRadius =  3.0f;
    self.diaryCoverImage.layer.cornerRadius = 3.0f;
}

@end
