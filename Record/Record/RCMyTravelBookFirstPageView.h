//
//  RCMyTravelBookFirstPageView.h
//  Record
//
//  Created by abyssinaong on 2017. 4. 19..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyTravelBookFirstPageView : UIView

@property (weak, nonatomic) IBOutlet UIView *mapViewOfGoogleMap;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *fromFirstDayToLastDayLB;
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLB;
@property (weak, nonatomic) IBOutlet UILabel *totalDaysLB;
@property (weak, nonatomic) IBOutlet UILabel *totalPostsLB;
@property (weak, nonatomic) IBOutlet UILabel *totalPhotosLB;
@property NSMutableArray *latitudes;
@property NSMutableArray *longitudes;
@property NSIndexPath *recivedIndexPath;

@end

@interface RCMyTravelBookSecondPageView : UIView
@property (weak, nonatomic) IBOutlet UIView *mapViewOfGoogleMap;
@property (weak, nonatomic) IBOutlet UILabel *contentsOfPostingLB;
@property NSString *latitude;
@property NSString *longitude;
@property NSIndexPath *recivedIndexPath;
@property NSInteger inDiaryArrayNumber;

@end

@interface RCMyTravelBookRemainPhotoPageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *firstPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondPhotoImageView;

@end
