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
#import "RCInDiaryTableViewFooterView.h"
#import "RCInDiaryTableViewCell.h"
#import "RCInDiaryCollectionViewCell.h"

/* Record source import */
#import "RCDiaryManager.h"
#import "DateSource.h"

/* library import */
#import <SDWebImage/UIImageView+WebCache.h>

@interface RCInDiaryListViewController ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RCInDiaryTableViewCellDelegate, RCInDiaryTableViewHeaderDelegate, RCInDiaryTableViewFooterDelegate>

/* view */
@property (weak, nonatomic) IBOutlet UITableView *inDiaryListTableView;
@property (weak, nonatomic) IBOutlet UIView      *inDiaryTopSolderView;
@property (weak, nonatomic) IBOutlet UISlider    *inDIaryTopSlider;

@property (nonatomic) RCInDiaryTableViewCell     *inDiaryTableViewCell;

@property (weak, nonatomic) RCInDiaryTableViewHeaderView *inDiaryHeaderView;

/* data */
@property (nonatomic) RLMResults<RCInDiaryRealm *>   *inDiaryResults;
@property (nonatomic) RCDiaryManager *manager;

@property (nonatomic) BOOL isLocationLoding;

@end

@implementation RCInDiaryListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.diaryRealm = [self.manager.diaryResults objectAtIndex:self.indexPath.row];
    
    self.manager.inDiaryResults = self.diaryRealm.inDiaryArray;
    
    self.inDiaryResults = [self.diaryRealm.inDiaryArray sortedResultsUsingKeyPath:@"inDiaryReportingDate" ascending:NO];
    
    [self.inDiaryListTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [RCDiaryManager diaryManager];
    
    self.diaryRealm = [self.manager.diaryResults objectAtIndex:self.indexPath.row];
    
    self.inDiaryResults = [self.diaryRealm.inDiaryArray sortedResultsUsingKeyPath:@"inDiaryReportingDate" ascending:NO];
    
    self.isLocationLoding = YES;

    // Do any additional setup after loading the view.
    UINib *headerViewNib = [UINib nibWithNibName:@"RCInDiaryTableViewHeaderView" bundle:nil];
    [self.inDiaryListTableView registerNib:headerViewNib
        forHeaderFooterViewReuseIdentifier:@"RCInDiaryTableViewHeaderView"];
    
    UINib *tableCellNib = [UINib nibWithNibName:@"RCInDiaryTableViewCell" bundle:nil];
    [self.inDiaryListTableView registerNib:tableCellNib forCellReuseIdentifier:@"RCInDiaryTableViewCell"];
    
    UINib *footerViewNib = [UINib nibWithNibName:@"RCInDiaryTableViewFooterView" bundle:nil];
    [self.inDiaryListTableView registerNib:footerViewNib
        forHeaderFooterViewReuseIdentifier:@"RCInDiaryTableViewFooterView"];
    
    [self.inDIaryTopSlider setThumbImage:[UIImage imageNamed:@"RC_walk_icon"] forState:UIControlStateNormal];
    [self.inDIaryTopSlider setThumbImage:[UIImage imageNamed:@"RC_walk_icon"] forState:UIControlStateHighlighted];
    [self.inDIaryTopSlider setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.inDIaryTopSlider addTarget:self action:@selector(changeTopSlider:) forControlEvents:UIControlEventValueChanged];

    self.inDiaryListTableView.rowHeight          = UITableViewAutomaticDimension;
    self.inDiaryListTableView.estimatedRowHeight = 500;
    
    /*
    self.manager = [RCDiaryManager diaryManager];
    
    [self.manager clearInDiaryItemAtIndexPaths];
    [self.manager requestInDiaryListWithCompletionHandler:^(BOOL isSuccess, id responseData) {
        
        if(isSuccess) {
            
            [self.inDiaryListTableView reloadData];
            
            [self.inDiaryListTableView reloadInputViews];
            
            [self.view layoutIfNeeded];
        }
    }];
     */
    
    [self.inDiaryListTableView reloadData];
}

#pragma mark - TableView DataSource
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return [self.manager inDiaryNumberOfItems];
    
    return [self.inDiaryResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    self.indexPath = indexPath;
    
//    RCInDiaryData *inDiaryData = [self.manager inDiaryDataAtIndexPath:indexPath];
    RCInDiaryRealm *inDiartRealm = [self.inDiaryResults objectAtIndex:indexPath.row];
    
    RCInDiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCInDiaryTableViewCell" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    
    /* table view cell custom */
    cell.inDiaryMainLocationLabel.text = inDiartRealm.inDiaryLocationCountry;
    cell.inDiarySubLocationLabel.text  = inDiartRealm.inDiaryLocationName;
    
    NSString *dayStr = [DateSource componentsWithFromDate:self.diaryRealm.diaryStartDate
                                               withToDate:inDiartRealm.inDiaryReportingDate];
    
    cell.inDiaryDaysLabel.text         = [@"DAY " stringByAppendingString:dayStr];
    cell.inDiaryDateLabel.text         = [DateSource convertWithDate:inDiartRealm.inDiaryReportingDate
                                                              format:@"yyyy-MM-dd HH:mm:ss"];
    cell.inDiaryContentLabel.text      = inDiartRealm.inDiaryContent;
    
    /* collection view item custom */
    CGFloat collectionViewSize = cell.inDiaryImageCollectionView.frame.size.width;

    cell.inDiaryImageCollectionViewFlowLayout.itemSize = CGSizeMake(collectionViewSize, collectionViewSize * 0.6);
    cell.inDiaryImageCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSInteger imageCount = [[self.inDiaryResults objectAtIndex:indexPath.row].inDiaryPhotosArray count];
    if(imageCount == 0) {
        [cell.inDiaryEmptyImageView setHidden:NO];
    } else {
        [cell.inDiaryEmptyImageView setHidden:YES];
    }
    
    /*
    if(imageCount == 0) {
        [cell.inDiaryEmptyImageView setHidden:NO];
        
    } else if(imageCount == 1) {
        
        [cell.inDiaryEmptyImageView setHidden:YES];
        
        cell.inDiaryImageCollectionViewFlowLayout.itemSize = CGSizeMake(collectionViewSize, collectionViewSize * 0.6);
        cell.inDiaryImageCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    } else {
        
        [cell.inDiaryEmptyImageView setHidden:YES];
        
        cell.inDiaryImageCollectionViewFlowLayout.itemSize = CGSizeMake(collectionViewSize-20, collectionViewSize * 0.6);
        cell.inDiaryImageCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
    }
     */
    
    [cell setDelegate:self];

    [cell.inDiaryImageCollectionView reloadData];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat selfWidth = self.view.frame.size.width;
    
    return (selfWidth * 0.75f) + 60 + (selfWidth * 0.6f) + 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    RCInDiaryTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCInDiaryTableViewHeaderView"];
    
    self.inDiaryHeaderView = headerView;
    
    if(self.diaryRealm != nil) {
        headerView.diaryCoverImageView.image = [UIImage imageWithData:self.diaryRealm.diaryCoverImage];
        headerView.coverDiaryTitleLabel.text = self.diaryRealm.diaryName;
        headerView.coverDiaryYearLabel.text  = [DateSource convertWithDate:self.diaryRealm.diaryStartDate
                                                                    format:@"YYYY"];
        
        headerView.infoDaysLabel.text        = [DateSource calculateWithFromDate:self.diaryRealm.diaryStartDate
                                                                      withToDate:self.diaryRealm.diaryEndDate];
        headerView.infoStepsLabel.text       = [NSString stringWithFormat:@"%ld", [self.diaryRealm.inDiaryArray count]];
        
        
        headerView.infoStartYearLabel.text   = [DateSource convertWithDate:self.diaryRealm.diaryStartDate format:@"YYYY"];
        headerView.infoStartMonthLabel.text  = [DateSource convertWithDate:self.diaryRealm.diaryStartDate format:@"MMMM dd일~"];
        
        headerView.infoEndYearLabel.text     = [DateSource convertWithDate:self.diaryRealm.diaryEndDate format:@"YYYY"];
        headerView.infoEndMonthLabel.text    = [DateSource convertWithDate:self.diaryRealm.diaryEndDate format:@"~MMMM dd일"];
        
        headerView.bottomStartDayLabel.text  = [DateSource convertWithDate:self.diaryRealm.diaryStartDate
                                                                    format:@"YYYY년 MM월 dd일"];
        
        NSComparisonResult dateCompareResult = [DateSource comparWithFromDate:self.diaryRealm.diaryEndDate
                                                                   withToDate:[NSDate date]];
        
        if(dateCompareResult == NSOrderedDescending) {
            [headerView.coverDiaryStatusView setBackgroundColor:[UIColor colorWithRed:255/255.0f
                                                                                green:106/255.0f
                                                                                 blue:58/255.0f
                                                                                alpha:1]];
            headerView.coverDiaryStatusLabel.text = @"NOW TRAVELING";
        } else {
            [headerView.coverDiaryStatusView setBackgroundColor:[UIColor colorWithRed:43/255.0f
                                                                                green:48/255.0f
                                                                                 blue:59/255.0f
                                                                                alpha:1]];
            
            headerView.coverDiaryStatusLabel.text = @"END TRAVELING";
        }
    }
    
    if(self.isLocationLoding) {
        [headerView.googleMapView showGoogleMap];
        self.isLocationLoding = NO;
    }
    
//    if(self.inDiaryCount != [self.inDiaryResults count]) {
//        [headerView.googleMapView showGoogleMap];
//        self.inDiaryCount = [self.inDiaryResults count];
//    }
    
    [headerView setDelegate:self];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 145;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    RCInDiaryTableViewFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCInDiaryTableViewFooterView"];
    
    footerView.bottomEndDayLabel.text = [DateSource convertWithDate:self.diaryRealm.diaryEndDate
                                                             format:@"YYYY년 MM월 dd일"];
    
    [footerView setDelegate:self];
    
    return footerView;
}

#pragma mark - ScrollView Delegate
//#warning scroll man logic modify
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat selfWidth  = self.view.frame.size.width;
    CGFloat selfHeight = (selfWidth * 0.75f) + 60 + (selfWidth * 0.6f) + 65;
    
    if([scrollView isKindOfClass:[UITableView class]]) {
        
        [self.inDIaryTopSlider setMinimumValue:((selfHeight+self.view.frame.size.height)/scrollView.contentSize.height) * 100];
        
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

#pragma mark - Tableview footer view button click method
- (void)tableViewFooterButton:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"InDiaryDetailSegue" sender:nil];
}

#pragma mark - Custom button click method
- (IBAction)clickCancelBarButton:(UIBarButtonItem *)sender {
    
    [self.inDiaryListTableView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

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

- (void)changeTopSlider:(UISlider *)sender {
    
//    CGFloat offsetY = ((self.inDiaryListTableView.contentOffset.y + self.view.frame.size.height) / self.inDiaryListTableView.contentSize.height) * sender.value;
//    
//    [self.inDiaryListTableView setContentOffset:CGPointMake(0, offsetY)];
}

#pragma mark - segue method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"DiaryDetailSegue"]) {
        
        UINavigationController *diaryDetailVC = [segue destinationViewController];
//        ((RCDiaryDetailViewController *)diaryDetailVC.topViewController).diaryData = self.diaryData;
//        ((RCDiaryDetailViewController *)diaryDetailVC.topViewController).indexPath = self.indexPath;
        
        ((RCDiaryDetailViewController *)diaryDetailVC.topViewController).diaryRealm  = self.diaryRealm;
        
    } else if([segue.identifier isEqualToString:@"InDiaryDetailSegue"]) {
        
//        if(sender != nil) {
//            RCInDiaryData *diaryData = [[RCDiaryManager diaryManager] inDiaryDataAtIndexPath:(NSIndexPath*)sender];
            
            UINavigationController *navigationVC = [segue destinationViewController];
            RCInDiaryDetailViewController *inDiaryDetailVC = (RCInDiaryDetailViewController *)navigationVC.topViewController;
            
            inDiaryDetailVC.diaryIndexPath = self.indexPath;
            inDiaryDetailVC.indexPath      = (NSIndexPath*)sender;
            
//            inDiaryDetailVC.inDiaryData = diaryData;
            
//            inDiaryDetailVC.diaryRealm  = self.diaryRealm;
//            inDiaryDetailVC.diaryPk     = self.diaryRealm.diaryPk;
            
//        }
        
    } else if([segue.identifier isEqualToString:@"InDiaryLocationSegue"]) {
        
        if(sender != nil) {
            
//            self.manager.in
            
            //RCInDiaryData *diaryData = [[RCDiaryManager diaryManager] inDiaryDataAtIndexPath:(NSIndexPath*)sender];
            
            RCInDiaryLocationViewController *locationVC = [segue destinationViewController];
            
            locationVC.inDiartRealm = [self.inDiaryResults objectAtIndex:((NSIndexPath*)sender).row];
            
//            locationVC.inDiaryData = diaryData;
//            locationVC.inDia
            locationVC.indexPath   = (NSIndexPath*)sender;
        }
        
    }
}

#pragma mark - unwind segue method
- (IBAction)unwindForInDiaryList:(UIStoryboardSegue *)sender {
    
//    [self.manager clearInDiaryItemAtIndexPaths];
//    [self.manager requestInDiaryListWithCompletionHandler:^(BOOL isSuccess, id responseData) {
//        
//        if(isSuccess) {
//            
//            [self.inDiaryListTableView reloadData];
//            
//            [self.view layoutIfNeeded];
//        }
//    }];
    
    if([sender.identifier isEqualToString:@"unwindDiaryList"]) {
        self.isLocationLoding = YES;
    }
    
    [self.inDiaryListTableView reloadData];
}

@end
