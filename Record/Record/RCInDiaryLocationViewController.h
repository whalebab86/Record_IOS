//
//  RCInDiaryLocationViewController.h
//  Record
//
//  Created by CLAY on 2017. 4. 9..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCDiaryData.h"
#import "RCDiaryRealm.h"

@interface RCInDiaryLocationViewController : UIViewController

@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) RCInDiaryData *inDiaryData;

@property (nonatomic) RCInDiaryRealm *inDiartRealm;

@end
