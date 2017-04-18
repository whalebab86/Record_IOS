//
//  RCInDiaryTableViewHeaderView.m
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryTableViewHeaderView.h"

@interface RCInDiaryTableViewHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *inDiaryTripStartView;

@property (weak, nonatomic) RCInDiaryLocationView *mapView;

@end

@implementation RCInDiaryTableViewHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    RCInDiaryLocationView *googleMapView = [[[NSBundle mainBundle] loadNibNamed:@"RCInDiaryLocationView"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    
    [googleMapView setFrame:self.inDiaryMapView.bounds];
    
    self.googleMapView = googleMapView;
    
    [self.inDiaryMapView setClipsToBounds:YES];
    [self.inDiaryMapView addSubview:googleMapView];
    
    self.inDiaryMapView = googleMapView;
    
    self.mapView = googleMapView;
    
    [self.inDiaryTripStartView.layer setCornerRadius:self.inDiaryTripStartView.frame.size.height/2];
    [self.inDiaryTripStartView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.inDiaryTripStartView.layer setBorderWidth:1];
    
    [self.inDiaryTripStartView setClipsToBounds:YES];
}

- (IBAction)clickLocationMaskButton:(id)sender {
    
    [self.delegate showInDiaryLocationView];
}
@end
