//
//  RCMyTravelBookFirstPageView.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 19..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMyTravelBookFirstPageView.h"

@import GoogleMaps;

@implementation RCMyTravelBookFirstPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude.floatValue
                                                            longitude:self.longitude.floatValue
                                                                 zoom:4];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapViewOfGoogleMap.bounds camera:camera];
    mapView.mapType = kGMSTypeHybrid;
    [self.mapViewOfGoogleMap addSubview:mapView];
    mapView.accessibilityElementsHidden = NO;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView;
    
}

@end

@implementation RCMyTravelBookSecondPageView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude.floatValue
                                                            longitude:self.longitude.floatValue
                                                                 zoom:4];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapViewOfGoogleMap.bounds camera:camera];
    mapView.mapType = kGMSTypeHybrid;
    [self.mapViewOfGoogleMap addSubview:mapView];
    mapView.accessibilityElementsHidden = NO;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView;
    
    
}

@end

@implementation RCMyTravelBookRemainPhotoPageView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
