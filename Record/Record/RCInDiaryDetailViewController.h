//
//  RCInDiaryDetailViewController.h
//  Record
//
//  Created by CLAY on 2017. 4. 7..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDiaryData.h"
#import "RCDiaryRealm.h"

@interface RCInDiaryDetailViewController : UIViewController

@property (nonatomic) RCInDiaryData  *inDiaryData;

@property (nonatomic) NSIndexPath    *diaryIndexPath;
@property (nonatomic) NSIndexPath    *indexPath;

@property (nonatomic) RCDiaryRealm   *diaryRealm;

@property (nonatomic) RCInDiaryRealm *inDiaryRealm;
@property (nonatomic) RLMResults<RCInDiaryRealm *>   *inDiaryResults;

@property (nonatomic) NSString       *diaryPk;
@property (nonatomic) NSString       *inDiaryPk;

@end


@interface RCInDiaryListViewCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *inDiaryCollectionImageView;

@end
