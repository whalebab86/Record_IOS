//
//  RCInDiaryLocationView.h
//  Record
//
//  Created by CLAY on 2017. 4. 9..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCDiaryManager.h"

@import GoogleMaps;

@protocol RCInDiaryLocationDelegate <NSObject>

-(void)googleMapViewDidLoad:(GMSMapView *)mapView;

@end

@interface RCInDiaryLocationView : UIView

@property (nonatomic) id<RCInDiaryLocationDelegate> delegate;

@property (nonatomic) RLMArray<RCInDiaryRealm *>   *inDiaryResults;

- (void)showGoogleMap;

- (void)googleMapCameraChangedAtIndex:(NSIndexPath *)indexPath whtiData:(RCInDiaryRealm *)data;
- (void)googleMapCameraChangedDefault;

@end
