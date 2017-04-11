//
//  RCInDiaryListViewController.m
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

/* Record controller import */
#import "RCInDiaryListViewController.h"
#import "RCDiaryDetailViewController.h"
#import "RCInDiaryDetailViewController.h"
#import "RCInDiaryLocationViewController.h"

/* Record view import */
#import "RCInDiaryTableViewHeaderView.h"
#import "RCInDiaryTableViewCell.h"
#import "RCInDiaryCollectionViewCell.h"

/* Record source import */
#import "RCDiaryManager.h"

/* library import */
#import <SDWebImage/UIImageView+WebCache.h>

@interface RCInDiaryListViewController ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RCInDiaryTableViewCellDelegate, RCInDiaryTableViewHeaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *inDiaryListTableView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryTopSolderView;
@property (weak, nonatomic) IBOutlet UISlider *inDIaryTopSlider;

@property (nonatomic) RCInDiaryTableViewCell *inDiaryTableViewCell;

@property (nonatomic) RCDiaryManager *manager;

@property NSIndexPath *indexPath;

@end

@implementation RCInDiaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UINib *headerViewNib = [UINib nibWithNibName:@"RCInDiaryTableViewHeaderView" bundle:nil];
    [self.inDiaryListTableView registerNib:headerViewNib forHeaderFooterViewReuseIdentifier:@"RCInDiaryTableViewHeaderView"];
    
    UINib *tableCellNib = [UINib nibWithNibName:@"RCInDiaryTableViewCell" bundle:nil];
    [self.inDiaryListTableView registerNib:tableCellNib forCellReuseIdentifier:@"RCInDiaryTableViewCell"];
    
    [self.inDIaryTopSlider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.inDIaryTopSlider setContentMode:UIViewContentModeScaleToFill];

    
    self.inDiaryListTableView.rowHeight          = UITableViewAutomaticDimension;
    self.inDiaryListTableView.estimatedRowHeight = 500;
    
    self.manager = [RCDiaryManager diaryManager];
    
    [self.manager clearInDiaryItemAtIndexPaths];
    [self.manager requestInDiaryListWithCompletionHandler:^(BOOL isSuccess, id responseData) {
        
        if(isSuccess) {
            
            [self.inDiaryListTableView reloadData];
            
            [self.inDiaryListTableView reloadInputViews];
            
            [self.view layoutIfNeeded];
        }
    }];
}

#pragma mark - TableView DataSource
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.manager inDiaryNumberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexPath = indexPath;
    
    RCInDiaryData *inDiaryData = [self.manager inDiaryDataAtIndexPath:indexPath];
    
    RCInDiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCInDiaryTableViewCell" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    
    /* table view cell custom */
    cell.inDiaryMainLocationLabel.text = inDiaryData.inDiaryMainLoacation;
    cell.inDiarySubLocationLabel.text  = inDiaryData.inDiarySubLocation;
    cell.inDiaryDaysLabel.text         = [@"DAY " stringByAppendingString:inDiaryData.inDiaryDay];
    cell.inDiaryDateLabel.text         = inDiaryData.inDiaryWriteDate;
    cell.inDiaryContentLabel.text      = inDiaryData.inDiaryContent;
    
    /* collection view item custom */
    CGFloat collectionViewSize = cell.inDiaryImageCollectionView.frame.size.width;
    
    if([self.manager inDiaryNumberOfCoverItemsAtIndexPath:self.indexPath] == 0) {
        [cell.inDiaryEmptyImageView setHidden:NO];
        
    } else if([self.manager inDiaryNumberOfCoverItemsAtIndexPath:self.indexPath] == 1) {
        
        [cell.inDiaryEmptyImageView setHidden:YES];
        
        cell.inDiaryImageCollectionViewFlowLayout.itemSize = CGSizeMake(collectionViewSize, collectionViewSize * 0.6);
        cell.inDiaryImageCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    } else {
        
        [cell.inDiaryEmptyImageView setHidden:YES];
        
        cell.inDiaryImageCollectionViewFlowLayout.itemSize = CGSizeMake(collectionViewSize-20, collectionViewSize * 0.6);
        cell.inDiaryImageCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
    }
    
    [cell setDelegate:self];

    [cell.inDiaryImageCollectionView reloadData];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    RCInDiaryTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCInDiaryTableViewHeaderView"];
    
    [headerView setDelegate:self];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat selfWidth = self.view.frame.size.width;
    
    return (selfWidth * 0.8) + 60 + (selfWidth * 0.8) + 65;
}

#pragma mark - ScrollView Delegate
//#warning scroll man logic modify
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if([scrollView isKindOfClass:[UITableView class]]) {
        [self.inDIaryTopSlider setMinimumValue:((730+self.view.frame.size.height)/scrollView.contentSize.height) * 100];
        
        [self.inDIaryTopSlider setValue:((scrollView.contentOffset.y+self.view.frame.size.height)/scrollView.contentSize.height) * 100 animated:YES];
    }
}

#pragma mark - IndiaryTableViewCell view Delegate
- (void)button:(UIButton *)button buttonType:(RCInDiaryButton)type indexPath:(NSIndexPath *)indexPath {
    
    if(type == RCInDiaryButtonWrite) {
        
        [self performSegueWithIdentifier:@"InDiaryDetailSegue" sender:indexPath];
    } else if(type == RCInDiaryButtonAdd) {
        
        [self performSegueWithIdentifier:@"InDiaryDetailSegue" sender:nil];
    } else if(type == RCInDiaryButtonLocation) {
        
        [self performSegueWithIdentifier:@"InDiaryLocationSegue" sender:indexPath];
    }
}

#pragma mark - IndiaryTableHeaderView view Delegate
- (void)showInDiaryLocationView {
    
    [self performSegueWithIdentifier:@"InDiaryLocationSegue" sender:nil];
}

#pragma mark - Custom button click method
- (IBAction)clickInDiaryOptionBarButtonItem:(UIBarButtonItem *)sender {
    
    UIAlertController *optionAlert = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    /* Diary settings action */
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Diary settings"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self performSegueWithIdentifier:@"DiaryDetailSegue" sender:nil];
                                                         }];
    [optionAlert addAction:settingAction];
    
    
    /* Create diary book action */
    UIAlertAction *bookAction = [UIAlertAction actionWithTitle:@"Create diary book"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                        }];
    [optionAlert addAction:bookAction];
    
    /* Cancel action */
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [optionAlert addAction:cancelAction];
    
    [self presentViewController:optionAlert animated:YES completion:nil];
}

#pragma mark - segue method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"DiaryDetailSegue"]) {
        
        UINavigationController *diaryDetailVC = [segue destinationViewController];
        ((RCDiaryDetailViewController *)diaryDetailVC.topViewController).diaryData = self.diaryData;
        ((RCDiaryDetailViewController *)diaryDetailVC.topViewController).indexPath = self.indexPath;
        
    } else if([segue.identifier isEqualToString:@"InDiaryDetailSegue"]) {
        
        if(sender != nil) {
            RCInDiaryData *diaryData = [[RCDiaryManager diaryManager] inDiaryDataAtIndexPath:(NSIndexPath*)sender];
            
            UINavigationController *navigationVC = [segue destinationViewController];
            RCInDiaryDetailViewController *inDiaryDetailVC = (RCInDiaryDetailViewController *)navigationVC.topViewController;
            
            inDiaryDetailVC.inDiaryData = diaryData;
            inDiaryDetailVC.indexPath   = (NSIndexPath*)sender;
        }
    } else if([segue.identifier isEqualToString:@"InDiaryLocationSegue"]) {
        
        if(sender != nil) {
            RCInDiaryData *diaryData = [[RCDiaryManager diaryManager] inDiaryDataAtIndexPath:(NSIndexPath*)sender];
            
            RCInDiaryLocationViewController *locationVC = [segue destinationViewController];
            
            locationVC.inDiaryData = diaryData;
            locationVC.indexPath   = (NSIndexPath*)sender;
        }
    }
}

- (IBAction)unwindForInDiaryList:(UIStoryboard *)sender {
    
    [self.manager clearInDiaryItemAtIndexPaths];
    [self.manager requestInDiaryListWithCompletionHandler:^(BOOL isSuccess, id responseData) {
        
        if(isSuccess) {
            
            [self.inDiaryListTableView reloadData];
            
            [self.view layoutIfNeeded];
        }
    }];
    
    NSLog(@"unwindForInDiaryList");
}

@end
