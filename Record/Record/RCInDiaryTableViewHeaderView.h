//
//  RCInDiaryTableViewHeaderView.h
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCInDiaryLocationView.h"

@protocol RCInDiaryTableViewHeaderDelegate <NSObject>

- (void)showInDiaryLocationView;

@end

@interface RCInDiaryTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic) id<RCInDiaryTableViewHeaderDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *diaryCoverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *coverProfieImageView;
@property (weak, nonatomic) IBOutlet UILabel     *coverProfileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *coverDiaryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *coverDiaryYearLabel;

@property (weak, nonatomic) IBOutlet UIView      *coverDiaryStatusView;
@property (weak, nonatomic) IBOutlet UILabel     *coverDiaryStatusLabel;

@property (weak, nonatomic) IBOutlet UIView      *inDiaryMapView;

@property (weak, nonatomic) IBOutlet UILabel     *infoDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel     *infoCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel     *infoStepsLabel;

@property (weak, nonatomic) IBOutlet UILabel     *bottomStartDayLabel;

@property (weak, nonatomic) RCInDiaryLocationView *googleMapView;

@end
