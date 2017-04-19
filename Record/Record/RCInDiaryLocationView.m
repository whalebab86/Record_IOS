//
//  RCInDiaryLocationView.m
//  Record
//
//  Created by CLAY on 2017. 4. 9..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryLocationView.h"

/* library import */
#import <SDWebImage/UIImageView+WebCache.h>
#import "DateSource.h"

@interface RCInDiaryLocationView ()
<GMSMapViewDelegate>

@property (weak, nonatomic) GMSMapView *googleMapView;
@property (nonatomic) NSMutableArray *googleMarkerArray;
@property (weak, nonatomic) GMSMutablePath *googlePath;

@property (weak, nonatomic) GMSCameraPosition *camera;
@property (weak, nonatomic) GMSMarker *marker;

@property (nonatomic) BOOL isChangeAnimation;

@property (nonatomic) RCDiaryManager *manager;

@end

@implementation RCInDiaryLocationView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.manager = [RCDiaryManager diaryManager];
    
    self.googleMarkerArray = [[NSMutableArray alloc] init];
    
    self.isChangeAnimation = YES;
    
    [self showGoogleMap];
}

-(void)layoutSubviews {
    
    /* Google map frame 조정 */
    [self.googleMapView setFrame:self.bounds];
}

/* Google Map Load */
- (void)showGoogleMap {
    
    [self.googleMapView removeFromSuperview];
    
    CGFloat dafualtLatitude  = 38;
    CGFloat dafualtlongitude = 128;
    
    if([self.manager.inDiaryResults count] > 0) {
        dafualtLatitude = [[self.manager.inDiaryResults objectAtIndex:0].inDiaryLocationLatitude   doubleValue];
        dafualtlongitude = [[self.manager.inDiaryResults objectAtIndex:0].inDiaryLocationLongitude doubleValue];
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:dafualtLatitude
                                                            longitude:dafualtlongitude
                                                                 zoom:1];
    self.camera = camera;
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.googleMapView = mapView;
    
    [mapView setMinZoom:1 maxZoom:18];
    
    [self.googleMapView setDelegate:self];

    GMSMutablePath *path = [GMSMutablePath path];
    self.googlePath = path;

    GMSMarker *marker;
    
    [self.googleMarkerArray removeAllObjects];
    for (RCInDiaryRealm* data in self.manager.inDiaryResults) {
        
        marker = [self drawMarkerViewWithInDiary:data];
        marker.groundAnchor = CGPointMake(0.5, 0.5);
        
        [self.googleMarkerArray addObject:marker];
    }
    
    self.marker = marker;
    
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeColor = [UIColor blackColor];
    rectangle.strokeWidth = 2;
    rectangle.map = self.googleMapView;
    
    [self addSubview:mapView];
}

- (GMSMarker *)drawMarkerViewWithInDiary:(RCInDiaryRealm *) data {
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([data.inDiaryLocationLatitude doubleValue],
                                                                 [data.inDiaryLocationLongitude doubleValue]);
    
    [self.googlePath addCoordinate:position];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    
    UIView *markerView = [[UIView alloc] init];
    
    [markerView setFrame:CGRectMake(0, 0, 30, 30)];
    [markerView.layer setCornerRadius:markerView.frame.size.height/2.0f];
    
    [markerView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [markerView.layer setBorderWidth:2];
    
    [markerView setBackgroundColor:[UIColor blackColor]];
    [markerView setClipsToBounds:YES];
    
    [marker setTitle:[DateSource convertWithDate:data.inDiaryReportingDate format:@"yyyy-MM-dd"]];
    
    UIImageView *markerImageView = [[UIImageView alloc] initWithFrame:markerView.bounds];
    [markerView addSubview:markerImageView];
    
    marker.tracksViewChanges = NO;
    
    if([data.inDiaryPhotosArray count] > 0) {
 
        [markerImageView setImage:[UIImage imageWithData:[data.inDiaryPhotosArray objectAtIndex:0].inDiaryPhoto]];
    } else {
        
        [markerImageView setImage:[UIImage imageNamed:@"RecordLogoWithoutWord"]];
    }
    
    marker.iconView = markerView;
    marker.map = self.googleMapView;
    
    return marker;
}

- (void)googleMapCameraChangedAtIndex:(NSIndexPath *)indexPath whtiData:(RCInDiaryData *)data {
    
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([data.inDiarylongitude doubleValue],
                                                                  [data.inDiaryLatitude doubleValue]);
    
    GMSCameraUpdate *locationCam = [GMSCameraUpdate setTarget:locationCoordinate zoom:8];
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 2.0f] forKey:kCATransactionAnimationDuration];

    [self.googleMapView animateWithCameraUpdate:locationCam];
    [self.googleMapView setSelectedMarker:[self.googleMarkerArray objectAtIndex:indexPath.row]];
    
    [CATransaction commit];
}

- (void)googleMapCameraChangedDefault {
    
    double minLatitude  = 36.0,  maxLatitude = 136.0;
    double minLongitude = 36.0, maxLongitude = 136.0;
    
    for (NSInteger i = 0; i < [self.googleMarkerArray count]; i ++) {
        
        GMSMarker *marker = [self.googleMarkerArray objectAtIndex:i];
        
        if(i == 0) {
            minLatitude  = marker.position.latitude;
            maxLatitude  = marker.position.latitude;
            minLongitude = marker.position.longitude;
            maxLongitude = marker.position.longitude;
        } else {
            
            if(minLatitude > marker.position.latitude) {
                minLatitude = marker.position.latitude;
            } else if(maxLatitude < marker.position.latitude) {
                maxLatitude = marker.position.latitude;
            }
            
            if(minLongitude > marker.position.longitude) {
                minLongitude = marker.position.longitude;
            } else if(maxLongitude < marker.position.longitude) {
                maxLongitude = marker.position.longitude;
            }
        }
    }
    
    CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake(minLatitude, minLongitude);
    CLLocationCoordinate2D calgary = CLLocationCoordinate2DMake(maxLatitude, maxLongitude);
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:vancouver coordinate:calgary];
    GMSCameraPosition *camera = [self.googleMapView cameraForBounds:bounds insets:UIEdgeInsetsMake(40, 40, 40, 40)];
    
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 2.0f] forKey:kCATransactionAnimationDuration];

    [self.googleMapView animateToCameraPosition:camera];
    
    [CATransaction commit];
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
    
    if(self.isChangeAnimation) {
        
        [self googleMapCameraChangedDefault];
        
        [self.delegate googleMapViewDidLoad:mapView];
        
//        self.isChangeAnimation = NO;
    }
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    UIView *markerInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 80, 75)];
    [markerInfoView setBackgroundColor:[UIColor clearColor]];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 80, 30)];
    [titleView setBackgroundColor:[UIColor darkGrayColor]];
    [markerInfoView addSubview:titleView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width - 80, 40)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setAlpha:0.9];
    [markerInfoView addSubview:contentView];
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake((markerInfoView.frame.size.width / 2.0f) - 2.5f, 70, 5, 5)];
    [temp setBackgroundColor:[UIColor darkGrayColor]];
    [temp setAlpha:0.9];
    [markerInfoView addSubview:temp];
    
    return markerInfoView;
}

@end
