//
//  RCInDiaryDetailViewController.h
//  Record
//
//  Created by CLAY on 2017. 4. 7..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDiaryData.h"

@interface RCInDiaryDetailViewController : UIViewController

@property (nonatomic) RCInDiaryData *inDiaryData;
@property (nonatomic) NSIndexPath   *indexPath;

@end


@interface RCInDiaryListViewCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *inDiaryCollectionImageView;

@end
