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
    
    [self.inDiaryTripStartView.layer setCornerRadius:self.inDiaryTripStartView.frame.size.height/2];
    [self.inDiaryTripStartView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.inDiaryTripStartView.layer setBorderWidth:1];
    
    [self.inDiaryTripStartView setClipsToBounds:YES];
}

- (IBAction)clickLocationMaskButton:(id)sender {
    
    [self.delegate showInDiaryLocationView];
}
@end
