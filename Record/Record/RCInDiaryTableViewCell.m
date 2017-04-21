//
//  RCInDiaryTableViewCell.m
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryTableViewCell.h"

#import "RCDiaryManager.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface RCInDiaryTableViewCell ()
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inDiaryInfoAreaView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryAddButtonView;

@property (weak, nonatomic) IBOutlet UIButton *inDiaryLikeButton;
@property (weak, nonatomic) IBOutlet UIButton *inDiaryLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *inDiaryWriteButton;
@property (weak, nonatomic) IBOutlet UIButton *inDiaryShareButton;

@property (nonatomic) RCDiaryManager *manager;

@end

@implementation RCInDiaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *grayColor = [UIColor colorWithRed:101/255.0
                                            green:104/255.0
                                             blue:111/255.0
                                            alpha:1];
    
    UIColor *whiteColor = [UIColor whiteColor];
    
    [self.inDiaryAddButtonView.layer setBorderColor:grayColor.CGColor];
    [self.inDiaryAddButtonView.layer setBorderWidth:2];
    [self.inDiaryAddButtonView.layer setCornerRadius:self.inDiaryAddButtonView.frame.size.height/2.0f];
    [self.inDiaryAddButtonView setClipsToBounds:YES];
    
    [self.inDiaryInfoAreaView.layer setCornerRadius:3];
    [self.inDiaryInfoAreaView setClipsToBounds:YES];
    
    [self.inDiaryLikeButtonView.layer setBorderColor:whiteColor.CGColor];
    [self.inDiaryLikeButtonView.layer setBorderWidth:1];
    [self.inDiaryLikeButtonView.layer setCornerRadius:3];
    [self.inDiaryLikeButtonView setClipsToBounds:YES];
    
    [self.inDiaryMapButtonView.layer setBorderColor:whiteColor.CGColor];
    [self.inDiaryMapButtonView.layer setBorderWidth:1];
    [self.inDiaryMapButtonView.layer setCornerRadius:3];
    [self.inDiaryMapButtonView setClipsToBounds:YES];
    
    [self.inDiaryShareButtonView.layer setBorderColor:whiteColor.CGColor];
    [self.inDiaryShareButtonView.layer setBorderWidth:1];
    [self.inDiaryShareButtonView.layer setCornerRadius:3];
    [self.inDiaryShareButtonView setClipsToBounds:YES];
    
    [self.inDiaryWriteButtonView.layer setBorderColor:whiteColor.CGColor];
    [self.inDiaryWriteButtonView.layer setBorderWidth:1];
    [self.inDiaryWriteButtonView.layer setCornerRadius:3];
    [self.inDiaryWriteButtonView setClipsToBounds:YES];
    
    UINib *collectionViewCellNib = [UINib nibWithNibName:@"RCInDiaryCollectionViewCell" bundle:nil];
    [self.inDiaryImageCollectionView registerNib:collectionViewCellNib
                      forCellWithReuseIdentifier:@"RCInDiaryCollectionViewCell"];
    
    self.manager = [RCDiaryManager diaryManager];
    
    [self.inDiaryImageCollectionView setDelegate:self];
    [self.inDiaryImageCollectionView setDataSource:self];
}

- (IBAction)clickInDiaryButton:(UIButton *)sender {
    
    
    RCInDiaryButton buttonType;
    
    if([sender isEqual:self.inDiaryLikeButton]) {
        buttonType = RCInDiaryButtonLike;
        
    } else if([sender isEqual:self.inDiaryLocationButton]) {
        buttonType = RCInDiaryButtonLocation;
        
    } else if([sender isEqual:self.inDiaryShareButton]) {
        buttonType = RCInDiaryButtonShare;
        
    } else if([sender isEqual:self.inDiaryWriteButton]) {
        buttonType = RCInDiaryButtonWrite;
        
    } else {
        buttonType = RCInDiaryButtonAdd;
    }
    
    [self.delegate button:sender buttonType:buttonType indexPath:self.indexPath];
}

#pragma mark - Collection view Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return [self.manager inDiaryNumberOfCoverItemsAtIndexPath:self.indexPath];
    
    RLMResults<RCInDiaryRealm*> *result = [self.manager.inDiaryResults sortedResultsUsingKeyPath:@"inDiaryReportingDate"
                                                                                      ascending:NO];
    
    NSInteger count = [[result objectAtIndex:self.indexPath.row].inDiaryPhotosArray count];
    
    return count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCInDiaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCInDiaryCollectionViewCell" forIndexPath:indexPath];

    RLMResults<RCInDiaryRealm*> *result = [self.manager.inDiaryResults sortedResultsUsingKeyPath:@"inDiaryReportingDate"
                                                                                       ascending:NO];
    
    RCInDiaryPhotoRealm *photo = [[result objectAtIndex:self.indexPath.row].inDiaryPhotosArray objectAtIndex:indexPath.row];
    
    
    if([[result objectAtIndex:self.indexPath.row].inDiaryPhotosArray count] > 1) {
        [self.inDiaryImageCollectionViewFlowLayout setItemSize:CGSizeMake(self.inDiaryImageCollectionView.frame.size.width-20,
                                                                          self.inDiaryImageCollectionView.frame.size.height)];
    } else {
        [self.inDiaryImageCollectionViewFlowLayout setItemSize:CGSizeMake(self.inDiaryImageCollectionView.frame.size.width,
                                                                          self.inDiaryImageCollectionView.frame.size.height)];
    }
    /*
     */
    
    [cell.inDiaryCollectionViewCellImageVIew setImage:[UIImage imageWithData:photo.inDiaryPhoto]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RLMResults<RCInDiaryRealm*> *result = [self.manager.inDiaryResults sortedResultsUsingKeyPath:@"inDiaryReportingDate"
                                                                                       ascending:NO];
    
    RLMArray<RCInDiaryPhotoRealm *><RCInDiaryPhotoRealm> *photo = [result objectAtIndex:self.indexPath.row].inDiaryPhotosArray;
    
    [self.delegate inDiaryPhoto:photo diaryIndexPath:self.indexPath photoIndexPath:indexPath];
}

@end
