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
#import "RCDiaryManager.h"
#import "RCMyTravelDiaryBookViewController.h"

@interface RCMyDiaryViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *rcMyDiaryCollectionView;
@property (weak, nonatomic) IBOutlet RCMyDiaryCollectionViewFlowLayout *rcMyDiaryCollectionViewCellLayout;

@property (weak, nonatomic) IBOutlet UIView *coverViewForEmptyDiary;



@end

@implementation RCMyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rcMyDiaryCollectionView.delegate = self;
    self.rcMyDiaryCollectionView.dataSource = self;
    
    if ([RCDiaryManager diaryManager].diaryResults.count == 0) {
        self.coverViewForEmptyDiary.hidden = NO;
    } else {
        self.coverViewForEmptyDiary.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [RCDiaryManager diaryManager].diaryResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    RCMyDiaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCMyDiaryCollectionViewCell" forIndexPath:indexPath];
    cell.mainImage.image = [UIImage imageWithData:[RCDiaryManager diaryManager].diaryResults[indexPath.item].diaryCoverImage];
    cell.diaryTitleLB.text = [RCDiaryManager diaryManager].diaryResults[indexPath.item].diaryName;
    cell.totalPostNumberLB.text = [NSString stringWithFormat:@"%ld", [RCDiaryManager diaryManager].diaryResults[indexPath.item].inDiaryArray.count];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[NSCalendar currentCalendar]];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[indexPath.item].diaryStartDate];
    NSString *endDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[indexPath.item].diaryEndDate];
    cell.fromStartDateToEndDateLB.text = [startDate stringByAppendingString:[NSString stringWithFormat:@" ~ %@", endDate]];
    
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[RCDiaryManager diaryManager].diaryResults[indexPath.item].diaryStartDate toDate:[RCDiaryManager diaryManager].diaryResults[indexPath.item].diaryEndDate options:0];
    cell.totalTravelDateNumberLB.text = [NSString stringWithFormat:@"%ld", [components day]];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.rcMyDiaryCollectionView.frame.size.width*0.7, self.rcMyDiaryCollectionView.frame.size.height*0.6);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat leftInsetValue = (collectionView.bounds.size.width - flowLayout.itemSize.width)/2.0f;

    UIEdgeInsets inset = UIEdgeInsetsMake(0, leftInsetValue, 0, leftInsetValue);
    return inset;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *segueNavigationController = [segue destinationViewController];
    
    RCMyTravelDiaryBookViewController *travelDiaryBookVC = (RCMyTravelDiaryBookViewController *)segueNavigationController.topViewController;
    travelDiaryBookVC.recivedIndexPath = sender;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"RCMyTravelDiaryBookViewControllerSegue" sender:indexPath];
    
}


- (IBAction)cancelBarButtonItemAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
