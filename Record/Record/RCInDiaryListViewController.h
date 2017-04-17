//
//  RCInDiaryListViewController.h
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDiaryData.h"
#import "RCDiaryRealm.h"

@interface RCInDiaryListViewController : UIViewController

@property (nonatomic) RCDiaryData    *diaryData;
@property (nonatomic) RCDiaryRealm   *diaryRealm;

@end
