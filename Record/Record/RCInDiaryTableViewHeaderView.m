//
//  RCInDiaryTableViewHeaderView.m
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryTableViewHeaderView.h"

@import GoogleMaps;

@interface RCInDiaryTableViewHeaderView ()

@property (nonatomic) GMSMapView *googleMapView;

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
    
    [self showGoogleMap];
}

-(void)layoutSubviews {
    
    /* Google map frame 조정 */
    [self.googleMapView setFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.width * 0.8))];
}

/* Google Map Load */
- (void)showGoogleMap {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.86
                                                            longitude:135.20
                                                                 zoom:4];
    
    self.googleMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //    self.googleMapView.myLocationEnabled = YES;
    self.googleMapView.mapType = kGMSTypeSatellite;
    
    [self.inDiaryMapView addSubview:self.googleMapView];
}

@end
