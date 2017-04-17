//
//  RCMyDiaryViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 13..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMyDiaryViewController.h"
#import "RCMyDiaryCollectionViewCell.h"
#import "RCMyDiaryCollectionViewFlowLayout.h"

@interface RCMyDiaryViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDataSourcePrefetching>

@property (weak, nonatomic) IBOutlet UICollectionView *rcMyDiaryCollectionView;
@property (weak, nonatomic) IBOutlet RCMyDiaryCollectionViewFlowLayout *rcMyDiaryCollectionViewCellLayout;


@end

@implementation RCMyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rcMyDiaryCollectionView.delegate = self;
    self.rcMyDiaryCollectionView.dataSource = self;
    self.rcMyDiaryCollectionView.prefetchDataSource = self;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    RCMyDiaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCMyDiaryCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.rcMyDiaryCollectionView.frame.size.width*0.6, self.rcMyDiaryCollectionView.frame.size.height*0.6);
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //    CGFloat leftInsetValue = (self.mainCollectionView.frame.size.width - self.cellLayout.itemSize.width) / 2.0f;
    
    //((UICollectionViewFlowLayout *)collectionViewLayout).itemSize
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat leftInsetValue = (collectionView.frame.size.width - flowLayout.itemSize.width)/2.0f;
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, leftInsetValue, 0, leftInsetValue);
    
    return inset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
