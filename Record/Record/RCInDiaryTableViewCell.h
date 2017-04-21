//
//  RCInDiaryTableViewCell.h
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCInDiaryCollectionViewCell.h"

#import "RCDiaryRealm.h"

typedef NS_ENUM(NSInteger, RCInDiaryButton) {
    RCInDiaryButtonLike,
    RCInDiaryButtonLocation,
    RCInDiaryButtonShare,
    RCInDiaryButtonWrite,
    RCInDiaryButtonAdd
};

@protocol RCInDiaryTableViewCellDelegate <NSObject>

- (void)button:(UIButton *)button buttonType:(RCInDiaryButton)type indexPath:(NSIndexPath *)indexPath;
- (void)inDiaryPhoto:(RLMArray<RCInDiaryPhotoRealm *><RCInDiaryPhotoRealm> *)photo
      diaryIndexPath:(NSIndexPath *)diaryIndexPath
      photoIndexPath:(NSIndexPath *)photoIndexPath;

@end

@interface RCInDiaryTableViewCell : UITableViewCell

@property (nonatomic) id<RCInDiaryTableViewCellDelegate> delegate;

@property NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel     *inDiaryMainLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel     *inDiarySubLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inDiaryLocationImageView;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *inDiaryEmptyImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *inDiaryImageCollectionView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryImageView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *inDiaryImageCollectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet UIView *inDiaryLikeButtonView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryMapButtonView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryShareButtonView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryWriteButtonView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryCollectionViewConstraints;

@end
