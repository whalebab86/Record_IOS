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

@property (weak, nonatomic) IBOutlet UICollectionView           *inDiaryPhotoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *inDiaryPhotoFlowLayout;

@end

@implementation RCInDiaryPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.inDiaryPhotoCollectionView selectItemAtIndexPath:self.photoIndexPath
                                                  animated:YES
                                            scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
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
    
    [self.inDiaryPhotoFlowLayout setItemSize:CGSizeMake(self.inDiaryPhotoCollectionView.frame.size.width,
                                                        self.inDiaryPhotoCollectionView.frame.size.height)];
    
    cell.inDiaryPhotoCountLabel.text = [NSString stringWithFormat:@"%ld / %ld", indexPath.item + 1
                                        ,[self.inDiaryPhoto count]];
    
    return cell;
}

#pragma mark - Custom method
- (IBAction)clickCloseButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"unwindInDiaryList" sender:nil];
}


@end


@interface RCInDiaryPhotoCollectionViewCell ()

@end

@implementation RCInDiaryPhotoCollectionViewCell

@end
