//
//  RCMyDiaryCollectionViewCell.h
//  Record
//
//  Created by abyssinaong on 2017. 4. 13..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyDiaryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *diaryTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *fromStartDateToEndDateLB;
@property (weak, nonatomic) IBOutlet UILabel *totalPostNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *totalTravelDateNumberLB;
//@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
