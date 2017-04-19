//
//  RCMyTravelBookView.h
//  Record
//
//  Created by abyssinaong on 2017. 4. 19..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMaps;

@interface RCMyTravelBookSecondPageView : UIView
@property (weak, nonatomic) IBOutlet UIView *mapViewOfGoogleMap;
@property (weak, nonatomic) IBOutlet UILabel *contentsOfPostingLB;
@property NSString *latitude;
@property NSString *longitude;

@end
