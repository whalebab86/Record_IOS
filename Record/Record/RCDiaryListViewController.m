    //
//  RCDiaryListViewController.m
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

/* Record controller import */
#import "RCDiaryListViewController.h"
#import "RCDiaryDetailViewController.h"
#import "RCInDiaryListViewController.h"

/* Record view import */
#import "RCDiaryTableViewHeaderView.h"
#import "RCDiaryTableViewFooterView.h"
#import "RCDiaryListCustomTableViewCell.h"

/* Record source import */
#import "DateSource.h"
#import "RCDiaryManager.h"

/* library import */
#import <SDWebImage/UIImageView+WebCache.h>

@interface RCDiaryListViewController ()
<UITableViewDataSource, UITableViewDelegate, RCDiaryTableViewFooterDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *diaryTableView;

@property (nonatomic) UISearchController *searchController;

@property (nonatomic) NSMutableArray *diaryListArray;

@end

@implementation RCDiaryListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.diaryTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    /* Table view custom cell - xib */
    UINib *cellNib = [UINib nibWithNibName:@"RCDiaryListCustomTableViewCell" bundle:nil];
    [self.diaryTableView registerNib:cellNib forCellReuseIdentifier:@"RCDiaryListCustomTableViewCell"];
    
    /* Search controller custom */
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
   
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.searchBar.delegate        = self;
    searchController.searchBar.backgroundImage = [UIImage new];
    searchController.searchBar.tintColor       = [UIColor colorWithRed:0/255.0f
                                                                 green:122/255.0f
                                                                  blue:255/255.0f
                                                                 alpha:1];
    
    self.searchController = searchController;
    
    self.diaryTableView.tableHeaderView = searchController.searchBar;
    self.diaryTableView.contentOffset   = CGPointMake(0, searchController.searchBar.frame.size.height);
    
    [[RCDiaryManager diaryManager] requestDiaryListWithCompletionHandler:^(BOOL isSuccess, id responseData) {
        
        if(isSuccess) {
            
            [self.diaryTableView reloadData];
        }
    }];
}


#pragma mark - TableView DataSource
#pragma mark - TableView Delegate
/* Tableview numberOfRowsInSection */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[RCDiaryManager diaryManager] diaryNumberOfItems];
}


/* Tableview cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDiaryListCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDiaryListCustomTableViewCell"
                                                                           forIndexPath:indexPath];
    
    /* Tableview cell data */
    RCDiaryData *diaryData = [[RCDiaryManager diaryManager] diaryDataAtIndexPath:indexPath];
    
    cell.diaryTitleLabel.text      = diaryData.diaryName;
    cell.diaryYearLabel.text       = @"2017";
    cell.diaryMonthLabel.text      = @"merch";
    cell.diaryDaysLabel.text       = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.inDiaryCountLabel.text    = [NSString stringWithFormat:@"%ld", diaryData.inDiaryCount];
    
    cell.diaryYearLabel.text       = [[diaryData.diaryStartDate componentsSeparatedByString:@"-"] objectAtIndex:0];
    cell.diaryMonthLabel.text      = [DateSource formattedDateToMonth:diaryData.diaryStartDate];
    
    cell.diaryBottomDaysLabel.text = [DateSource calculateWithFromDate:diaryData.diaryStartDate
                                                            withToDate:diaryData.diaryEndDate];
    
    /* Tableview cell image[SDWebImage] */
    [cell.diaryMainImageView sd_setImageWithURL:[NSURL URLWithString:diaryData.diaryCoverImageUrl]
                               placeholderImage:[UIImage imageNamed:@"RCSignInUpTopImage"]];
    
    return cell;
}

/* Tableview didSelectRowAtIndexPath */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"InDiaryListSegue" sender:indexPath];
}

/* Tableview heightForRowAtIndexPath */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (self.view.frame.size.width * 0.6);
}


/* Tableview viewForHeaderInSection */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    /* Table view header view - xib */
    UINib *nib = [UINib nibWithNibName:@"RCDiaryTableViewHeaderView" bundle: nil];
    [self.diaryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"RCDiaryTableViewHeaderView"];
    
    RCDiaryTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCDiaryTableViewHeaderView"];
    
    return headerView;
}


/* Tableview heightForHeaderInSection */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return (self.view.frame.size.width * 0.8);
}


/* Tableview viewForFooterInSection */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NSString *footerNibIdentifier = @"";
    
    if([tableView numberOfRowsInSection:section] == 0) {
        
        /* Diary가 존재하지 않을 경우 Footer */
        footerNibIdentifier = @"RCDiaryTableViewFooterEmptyView";
    } else {
        
        /* Diary가 존재할 경우 Footer */
        footerNibIdentifier = @"RCDiaryTableViewFooterView";
    }
    
    /* Table view footer view - xib */
    UINib *nib = [UINib nibWithNibName:footerNibIdentifier bundle: nil];
    [self.diaryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:footerNibIdentifier];
    
    RCDiaryTableViewFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerNibIdentifier];
    
    /* Footerview button click delegate */
    [footerView setDelegate:self];
    
    return footerView;
}


/* Tableview heightForFooterInSection */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 80;
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchController.searchBar setText:@""];
    [self.searchController.searchBar resignFirstResponder];
    
//    self.diaryListArray
}

#pragma mark - Manual segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"DiaryDetailSegue"]) {
        
        RCDiaryData *diaryData = [[RCDiaryManager diaryManager] diaryDataAtIndexPath:(NSIndexPath *)sender];
        RCDiaryDetailViewController *diaryDetailVC = [segue destinationViewController];
        
        diaryDetailVC.diaryData = diaryData;
        diaryDetailVC.indexPath = (NSIndexPath *)sender;
        
    } else if([segue.identifier isEqualToString:@"InDiaryListSegue"]) {
        
        RCDiaryData *diaryData = [[RCDiaryManager diaryManager] diaryDataAtIndexPath:(NSIndexPath *)sender];
        RCInDiaryListViewController *inDiaryListVC = [segue destinationViewController];
        
        inDiaryListVC.diaryData = diaryData;
    }
}

#pragma mark - RCDiaryTableViewFooter Delegate
- (void)tableViewFooterButton:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"DiaryDetailAddSegue" sender:nil];
}

#pragma mark - Custom Segue
- (IBAction)unwindSegue:(UIStoryboardSegue *)sender {
    
    NSLog(@"unwindSegue");
    
    // 데이터 변경 완료 시점
    // 조회 or 변경된 데이터를 이 화면에 적용
    
    //
}

@end
