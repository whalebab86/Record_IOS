//
//  RCDiaryDetailViewController.h
//  Record
//
//  Created by CLAY on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDiaryData.h"

@interface RCDiaryDetailViewController : UIViewController

@property (nonatomic) RCDiaryData *diaryData;
@property (nonatomic) NSIndexPath *indexPath;

@end
