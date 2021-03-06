//
//  RCMyTravelBookFirstPageView.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 19..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMyTravelBookFirstPageView.h"
#import "RCDiaryManager.h"
@import GoogleMaps;


@interface RCMyTravelBookFirstPageView()
<GMSMapViewDelegate>
@property (weak, nonatomic) GMSMapView *mapView;


@end

@implementation RCMyTravelBookFirstPageView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.titleLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryName;
    
    /* inserted between dates */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[NSCalendar currentCalendar]];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryStartDate];
    NSString *endDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryEndDate];
    self.fromFirstDayToLastDayLB.text = [startDate stringByAppendingString:[NSString stringWithFormat:@" ~ %@", endDate]];
    
    /* inserted total days */
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryStartDate toDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryEndDate options:NSCalendarWrapComponents];
    self.totalDaysLB.text = [NSString stringWithFormat:@"%ld", [components day]+1];
    
    /* post number */
    NSInteger inDiaryPostNumber = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
    self.totalPostsLB.text = [NSString stringWithFormat:@"%ld", inDiaryPostNumber];
    
    /* photo number */
    NSInteger inDiaryPhotoNumber = 0;
    for (NSInteger i = 0; i < inDiaryPostNumber ; i++) {
        inDiaryPhotoNumber += [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i].inDiaryPhotosArray.count;
    }
    self.totalPhotosLB.text = [NSString stringWithFormat:@"%ld", inDiaryPhotoNumber];
    
    NSInteger countOfinDiary = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
    CGFloat totalDistanceMeter = 0;
    /* distance */
    for (NSInteger i = 0 ; i < countOfinDiary - 1 ; i++) {
        CLLocationDegrees startLatitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i].inDiaryLocationLatitude.floatValue;
        CLLocationDegrees startLongitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i].inDiaryLocationLongitude.floatValue;
        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
        
        CLLocationDegrees endtLatitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i+1].inDiaryLocationLatitude.floatValue;
        CLLocationDegrees endLongitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i+1].inDiaryLocationLongitude.floatValue;
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:endtLatitude longitude:endLongitude];
        
        CLLocationDistance distance = [endLocation distanceFromLocation:startLocation];
        totalDistanceMeter += distance;
        
    }
    self.totalDistanceLB.text = [NSString stringWithFormat:@"%.2lf", totalDistanceMeter/1000];
    
    /* google map and marker */
    GMSCameraPosition *camera;
    if ([RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count == 0) {
        
        camera = [GMSCameraPosition cameraWithLatitude:37.5653203 longitude:126.9745883 zoom:10];
    } else {
        camera = [GMSCameraPosition cameraWithLatitude:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[0].inDiaryLocationLatitude.floatValue longitude:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[0].inDiaryLocationLongitude.floatValue zoom:10];
    }
    
    NSInteger  gpsNum = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
    GMSMutablePath *path = [GMSMutablePath path];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapViewOfGoogleMap.bounds
                                            camera:camera];
    NSMutableArray *markerArray = [[NSMutableArray alloc] init];

    for (NSInteger latArrayCount = 0; latArrayCount < gpsNum ; latArrayCount ++) {
        CGFloat latitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[latArrayCount].inDiaryLocationLatitude.floatValue;
        CGFloat longitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[latArrayCount].inDiaryLocationLongitude.floatValue;
        
        CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake(latitude, longitude);
        
        [path addCoordinate:location2D];
        
        /* marker */
        GMSMarker *marker = [GMSMarker markerWithPosition:location2D];
        UIView *viewInMarker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        viewInMarker.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageViewInMarker = [[UIImageView alloc] initWithFrame:viewInMarker.frame];
        imageViewInMarker.layer.borderWidth = 2.0f;
        imageViewInMarker.layer.borderColor = [UIColor whiteColor].CGColor;
        imageViewInMarker.clipsToBounds = YES;
        marker.groundAnchor = CGPointMake(0.5, 0.5);
        imageViewInMarker.layer.cornerRadius = imageViewInMarker.frame.size.height/2.0f;
        if ([RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[latArrayCount].inDiaryPhotosArray.count != 0) {
            imageViewInMarker.image = [UIImage imageWithData:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[latArrayCount].inDiaryPhotosArray[0].inDiaryPhoto];
        } else {
            imageViewInMarker.image = [UIImage imageNamed:@"RecordLogoWithoutWord"];
        }
        
        [viewInMarker addSubview:imageViewInMarker];
        marker.iconView = imageViewInMarker;
        marker.tracksViewChanges = NO;
        
        marker.map = mapView;
        [markerArray addObject:marker];
        
    }
    
    /* google map poly line */
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blackColor];
    polyline.strokeWidth = 2.0f;
    
    CGFloat minLatitude = 36.0f;
    CGFloat maxLatitude = 136.0f;
    CGFloat minLongitude = 36.0f;
    CGFloat maxLongitude = 136.0f;
    
    for (NSInteger num = 0 ; num < markerArray.count ; num++ ) {
        GMSMarker *marker = markerArray[num];
        if (num == 0) {
            minLatitude = marker.position.latitude;
            maxLatitude = marker.position.latitude;
            minLongitude = marker.position.longitude;
            maxLongitude = marker.position.longitude;
        } else {
            
            if (minLatitude > marker.position.latitude) {
                minLatitude = marker.position.latitude;
            } else if (maxLatitude < marker.position.latitude) {
                maxLatitude = marker.position.latitude;
            }
            
            if (minLongitude > marker.position.longitude) {
                minLongitude = marker.position.longitude;
            } else if (maxLongitude < marker.position.longitude) {
                maxLongitude = marker.position.longitude;
            }
        }
    }
    
    CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake(minLatitude, minLongitude);
    CLLocationCoordinate2D calgary = CLLocationCoordinate2DMake(maxLatitude, maxLongitude);
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:vancouver coordinate:calgary];
    
    GMSCameraPosition *cameraPosition = [mapView cameraForBounds:bounds insets:UIEdgeInsetsMake(40, 40, 40, 40)];
    mapView.camera = cameraPosition;
    
    // The current zoom, 4, is outside of the range. The zoom will change to 10.
    [mapView setMinZoom:4 maxZoom:15];
    
    mapView.accessibilityElementsHidden = NO;
   
    polyline.map = mapView;
    mapView.delegate = self;
    self.mapView = mapView;
    self.mapViewOfGoogleMap.layer.cornerRadius = 3.0f;
    [self.mapViewOfGoogleMap addSubview:self.mapView];
    
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageView *snapShotImageView = [[UIImageView alloc] initWithImage:snapShotImage];
    snapShotImageView.frame = self.frame;
    NSInteger subViewsNumber = self.subviews.count - 1;
    while (subViewsNumber > -1) {
        [self.subviews[subViewsNumber] removeFromSuperview];
        subViewsNumber -= 1;
    }
    [self addSubview:snapShotImageView];
}

@end

@interface RCMyTravelBookSecondPageView()
<GMSMapViewDelegate>
@property (weak, nonatomic) GMSMapView *mapView;
@end

@implementation RCMyTravelBookSecondPageView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.contentsOfPostingLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[self.inDiaryArrayNumber].inDiaryContent;
    self.latitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[self.inDiaryArrayNumber].inDiaryLocationLatitude.stringValue;
    self.longitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[self.inDiaryArrayNumber].inDiaryLocationLongitude.stringValue;
    
    
    self.currentDayOfThisPostLB.text = [NSString stringWithFormat:@"%ld", self.inDiaryArrayNumber + 1];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude.floatValue
                                                            longitude:self.longitude.floatValue
                                                                 zoom:13];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.mapViewOfGoogleMap.bounds camera:camera];
    
    mapView.accessibilityElementsHidden = NO;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    UIView *viewInMarker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    viewInMarker.backgroundColor = [UIColor clearColor];
    UIImageView *imageViewInMarker = [[UIImageView alloc] initWithFrame:viewInMarker.frame];
    imageViewInMarker.clipsToBounds = YES;
    imageViewInMarker.layer.cornerRadius = imageViewInMarker.frame.size.height/2.0f;
    imageViewInMarker.layer.borderWidth = 2.0f;
    imageViewInMarker.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    NSUInteger inDiaryPhotosCount = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[self.inDiaryArrayNumber].inDiaryPhotosArray.count;
    if (inDiaryPhotosCount != 0) {
        imageViewInMarker.image = [UIImage imageWithData:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[self.inDiaryArrayNumber].inDiaryPhotosArray[0].inDiaryPhoto];
        
        /**/
        self.totalPhotoOfThisPost.text = [NSString stringWithFormat:@"%lu", inDiaryPhotosCount];
    } else {
        imageViewInMarker.image = [UIImage imageNamed:@"RecordLogoWithoutWord"];
        self.totalPhotoOfThisPost.text = @"0";
    }
    
    [viewInMarker addSubview:imageViewInMarker];
    marker.iconView = viewInMarker;
    marker.tracksViewChanges = NO;
    
    marker.map = mapView;
    mapView.delegate = self;
    self.mapView = mapView;
    self.mapViewOfGoogleMap.layer.cornerRadius = 3.0f;
    [self.mapViewOfGoogleMap addSubview:self.mapView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadInputViews];
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageView *snapShotImageView = [[UIImageView alloc] initWithImage:snapShotImage];
    snapShotImageView.frame = self.frame;
    NSInteger subViewsNumber = self.subviews.count - 1;
    while (subViewsNumber > -1) {
        [self.subviews[subViewsNumber] removeFromSuperview];
        subViewsNumber -= 1;
    }
    
    [self addSubview:snapShotImageView];
}

@end

@implementation RCMyTravelBookRemainPhotoPageView

 - (void)drawRect:(CGRect)rect {
 // Drawing code
     self.firstPhotoImageView.layer.cornerRadius = 3.0f;
     self.secondPhotoImageView.layer.cornerRadius = 3.0f;
     self.firstPhotoImageView.image = [UIImage imageWithData:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[self.inDiaryArrayNumber].inDiaryPhotosArray[self.inDiaryPhotosArrayCount].inDiaryPhoto];
 }

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadInputViews];
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageView *snapShotImageView = [[UIImageView alloc] initWithImage:snapShotImage];
    snapShotImageView.frame = self.frame;
    NSInteger subViewsNumber = self.subviews.count - 1;
    while (subViewsNumber > -1) {
        [self.subviews[subViewsNumber] removeFromSuperview];
        subViewsNumber -= 1;
    }
    [self addSubview:snapShotImageView];
}

@end
