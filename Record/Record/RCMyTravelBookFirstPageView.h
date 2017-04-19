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
@property NSString *latitude;
@property NSString *longitude;

@end
