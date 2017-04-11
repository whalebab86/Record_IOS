//
//  RCInDiaryTableViewHeaderView.m
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryTableViewHeaderView.h"

@interface RCInDiaryTableViewHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverProfieImageView;
@property (weak, nonatomic) IBOutlet UILabel     *coverProfileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *coverDiaryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *coverDiaryYearLabel;
@property (weak, nonatomic) IBOutlet UILabel     *coverDiaryStatusLabel;

@property (weak, nonatomic) IBOutlet UIView      *inDiaryMapView;

@property (weak, nonatomic) IBOutlet UILabel     *infoDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel     *infoStepsLabel;

@property (weak, nonatomic) IBOutlet UILabel     *bottomStartDayLabel;

@end

@implementation RCInDiaryTableViewHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIView *googleMapView = [[[NSBundle mainBundle] loadNibNamed:@"RCInDiaryLocationView"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    
    [googleMapView setFrame:self.inDiaryMapView.bounds];
    
    [self.inDiaryMapView setClipsToBounds:YES];
    [self.inDiaryMapView addSubview:googleMapView];
}

- (IBAction)clickLocationMaskButton:(id)sender {
    
    [self.delegate showInDiaryLocationView];
}
@end
