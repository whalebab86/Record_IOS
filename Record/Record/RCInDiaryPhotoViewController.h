//
//  RCInDiaryPhotoViewController.h
//  Record
//
//  Created by CLAY on 2017. 4. 20..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCDiaryRealm.h"

@interface RCInDiaryPhotoViewController : UIViewController

@property (nonatomic) RLMArray<RCInDiaryPhotoRealm *><RCInDiaryPhotoRealm> *inDiaryPhoto;

@property (nonatomic) NSIndexPath         *inDiaryIndexPath;
@property (nonatomic) NSIndexPath         *photoIndexPath;

@end


@interface RCInDiaryPhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *inDiaryPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryPhotoCountLabel;

@end
