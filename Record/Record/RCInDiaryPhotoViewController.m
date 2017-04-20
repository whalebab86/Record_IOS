//
//  RCInDiaryPhotoViewController.m
//  Record
//
//  Created by CLAY on 2017. 4. 20..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryPhotoViewController.h"

@interface RCInDiaryPhotoViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation RCInDiaryPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.inDiaryPhoto count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCInDiaryPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InDiaryPhotoCell"
                                                                           forIndexPath:indexPath];
    
    [cell.inDiaryPhotoImageView setImage:[UIImage imageWithData:[self.inDiaryPhoto
                                                                 objectAtIndex:indexPath.item].inDiaryPhoto]];
    
    cell.inDiaryPhotoCountLabel.text = [NSString stringWithFormat:@"%ld / %ld", indexPath.item + 1,
                                        [self.inDiaryPhoto count]];
    
    return cell;
}

- (IBAction)clickCloseButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"unwindInDiaryList" sender:nil];
}

@end


@interface RCInDiaryPhotoCollectionViewCell ()

@end

@implementation RCInDiaryPhotoCollectionViewCell

@end
