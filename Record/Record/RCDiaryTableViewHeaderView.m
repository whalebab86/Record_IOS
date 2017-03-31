//
//  RCDiaryTableViewHeaderView.m
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryTableViewHeaderView.h"

@import GoogleMaps;

@interface RCDiaryTableViewHeaderView ()

@property (nonatomic) GMSMapView *googleMapView;

@property (weak, nonatomic) IBOutlet UIView      *mapView;

@property (weak, nonatomic) IBOutlet UIView      *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserLocationLabel;
@property (weak, nonatomic) IBOutlet UIView      *profileUserNameIconView;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserNameIconLabel;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserDescription;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileConstraintsY;

@end

@implementation RCDiaryTableViewHeaderView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    /* 사용자 프로필정보 */
    [self initProfileInfo];
    
    /* Google map */
    [self showGoogleMap];
}

-(void)layoutSubviews {
    
    /* Google map frame 조정 */
    [self.googleMapView setFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.width * 0.8)-5)];
}

/* 사용자 프로필정보 세팅 */
- (void)initProfileInfo {
    
    /* profileImageView */
    [self.profileImageView.layer setCornerRadius:(self.profileImageView.frame.size.height/2.0f)];
    [self.profileImageView setBackgroundColor:[UIColor lightGrayColor]];
    
    /* profile username icon view */
    [self.profileUserNameIconView setClipsToBounds:YES];
    [self.profileUserNameIconView.layer setCornerRadius:self.profileUserNameIconView.frame.size.height / 2];
    [self.profileUserNameIconView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.profileUserNameIconView.layer setBorderWidth:1];
}

/* Google Map Load */
- (void)showGoogleMap {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.86
                                                            longitude:135.20
                                                                 zoom:4];
    
    self.googleMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    self.googleMapView.myLocationEnabled = YES;
    self.googleMapView.mapType = kGMSTypeSatellite;
    
    [self.mapView addSubview:self.googleMapView];
}

/* Profile view Move */
- (IBAction)didProfileMoveButton:(UIButton *)sender {
    
    CGFloat constant = self.profileConstraintsY.constant;
    
    if(constant > 0) {
        self.profileConstraintsY.constant = 0;
    } else {
        self.profileConstraintsY.constant = self.profileUserDescription.frame.size.height + 20;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if(self.profileConstraintsY.constant == 0) {
            
            self.profileUserNameIconLabel.text = @"▽";
            self.profileUserDescription.alpha  = 0;
        } else {
            
            self.profileUserNameIconLabel.text = @"△";
            self.profileUserDescription.alpha  = 1;
        }
        
        [self layoutIfNeeded];
    }];
}

@end
