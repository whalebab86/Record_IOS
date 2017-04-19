//
//  RCDiaryListCustomTableViewCell.h
//  Record
//
//  Created by CLAY on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDiaryListCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *diaryMainImageView;

@property (weak, nonatomic) IBOutlet UILabel     *diaryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryYearLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryKilometersLabel;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryCountLabel;

@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomYearLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomKmLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomInDiaryCount;
@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomEndYearLabel;
@property (weak, nonatomic) IBOutlet UILabel     *diaryBottomEndMonth;

@end
