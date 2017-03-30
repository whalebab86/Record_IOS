//
//  RCDiaryListViewController.m
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryListViewController.h"
#import "RCDiaryTableViewHeaderView.h"
#import "RCDiaryTableViewFooterView.h"
#import "RCDiaryListCustomTableViewCell.h"

@interface RCDiaryListViewController ()
<UITableViewDataSource, UITableViewDelegate, RCDiaryTableViewFooterDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *diaryTableView;

@property (nonatomic) UISearchController *searchController;

@end

@implementation RCDiaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    /* Table view custom cell - xib */
    UINib *cellNib = [UINib nibWithNibName:@"RCDiaryListCustomTableViewCell" bundle:nil];
    [self.diaryTableView registerNib:cellNib forCellReuseIdentifier:@"RCDiaryListCustomTableViewCell"];
    
    /* Search controller custom */
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //    searchController.searchResultsUpdater = self;
    
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
}


#pragma mark - TableView DataSource
#pragma mark - TableView Delegate
/* Tableview numberOfRowsInSection */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}


/* Tableview cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDiaryListCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDiaryListCustomTableViewCell"
                                                                           forIndexPath:indexPath];
    
    return cell;
}


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


#pragma mark - RCDiaryTableViewFooter Delegate
- (void)tableViewFooterButton:(UIButton *)button {
    
    NSLog(@"Click Add Button");
}

//#pragma mark - UISearchController Delegate
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    
//}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
//    [searchBar resignFirstResponder];
}

#pragma mark - Custom Segue
- (IBAction)unwindSegue:(UIStoryboardSegue *)sender {
    
}


#pragma mark - Custom method


@end
