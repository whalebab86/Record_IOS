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
    
    UIColor *color = [UIColor colorWithRed:255/228.0f green:255/228.0f blue:255/230.0f alpha:0.7];
    
    [self.inDiaryTripStartView.layer setCornerRadius:self.inDiaryTripStartView.frame.size.height/2];
    [self.inDiaryTripStartView.layer setBorderColor:color.CGColor];
    [self.inDiaryTripStartView.layer setBorderWidth:1];
    
    [self.inDiaryTripStartView setClipsToBounds:YES];
}

- (IBAction)clickLocationMaskButton:(id)sender {
    
    [self.delegate showInDiaryLocationView];
}
@end
