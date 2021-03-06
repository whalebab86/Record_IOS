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
#import "RCDiaryRealm.h"
#import "RCMemberInfo.h"

/* library import */
#import <Realm.h>
#import <SDWebImage/UIImageView+WebCache.h>

/* util import */
#import "RCUtilyValidation.h"

@interface RCDiaryListViewController ()
<UITableViewDataSource, UITableViewDelegate, RCDiaryTableViewFooterDelegate, UIScrollViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *diaryTableView;

@property (nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSMutableArray *diaryListArray;

@property (nonatomic) RCDiaryManager *manager;

@property (nonatomic) RCMemberInfo *memberInfo;

//@property (nonatomic) RLMResults<RCDiaryRealm *>   *diaryResults;

@end

@implementation RCDiaryListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.memberInfo = [[RCMemberInfo alloc] init];
    
    [self.diaryTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* isReset YES 일 경우 Realm 파일 삭제 */
    BOOL isReset = NO;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSArray<NSURL *> *realmFileURLs = @[
                                        config.fileURL,
                                        [config.fileURL URLByAppendingPathExtension:@"lock"],
                                        [config.fileURL URLByAppendingPathExtension:@"note"],
                                        [config.fileURL URLByAppendingPathExtension:@"management"]
                                        ];
    for (NSURL *URL in realmFileURLs) {

        NSLog(@"%@", URL);
        NSError *error = nil;
        if(isReset) {
            [manager removeItemAtURL:URL error:&error];
            if (error) {
                // handle error
            }
        } else {
            NSLog(@"%@", URL);
        }
    }
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.manager = [RCDiaryManager diaryManager];
    
    /* Table view header view - xib */
    UINib *nib = [UINib nibWithNibName:@"RCDiaryTableViewHeaderView" bundle: nil];
    [self.diaryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"RCDiaryTableViewHeaderView"];
    
    /* Table view custom cell - xib */
    UINib *cellNib = [UINib nibWithNibName:@"RCDiaryListCustomTableViewCell" bundle:nil];
    [self.diaryTableView registerNib:cellNib forCellReuseIdentifier:@"RCDiaryListCustomTableViewCell"];
    
    /* Search controller custom */
//    UISearchBar *searchController = [[UISearchBar alloc] ];
//   
//    searchController.hidesNavigationBarDuringPresentation = NO;
//    searchController.searchBar.delegate        = self;
//    searchController.searchBar.backgroundImage = [UIImage new];
//    searchController.searchBar.tintColor       = [UIColor colorWithRed:0/255.0f
//                                                                 green:122/255.0f
//                                                                  blue:255/255.0f
//                                                                 alpha:1];
//    
//    self.searchBar = searchController;
//    
//    self.diaryTableView.tableHeaderView = searchController.searchBar;
//    self.diaryTableView.contentOffset   = CGPointMake(0, searchController.searchBar.frame.size.height);
}


#pragma mark - TableView DataSource
#pragma mark - TableView Delegate
/* Tableview numberOfRowsInSection */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.manager.diaryResults count];
}


/* Tableview cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDiaryListCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCDiaryListCustomTableViewCell"
                                                                           forIndexPath:indexPath];
    
    RCDiaryRealm *diaryData = [self.manager.diaryResults objectAtIndex:indexPath.row];
    
    UIImage *resizeImage = [RCUtilyValidation setResizeImage:[UIImage imageWithData:diaryData.diaryCoverImage]
                                                 onImageView:cell.diaryMainImageView];
    
    cell.diaryMainImageView.image  = resizeImage;
    
    cell.diaryTitleLabel.text      = diaryData.diaryName;
    cell.diaryYearLabel.text       = [DateSource convertWithDate:diaryData.diaryStartDate format:@"YYYY"];
    cell.diaryMonthLabel.text      = [DateSource convertWithDate:diaryData.diaryStartDate format:@"MMMM dd일~"];
    cell.diaryDaysLabel.text       = [DateSource calculateWithFromDate:diaryData.diaryStartDate
                                                            withToDate:diaryData.diaryEndDate];
    
    cell.diaryBottomEndYearLabel.text   = [DateSource convertWithDate:diaryData.diaryEndDate format:@"YYYY"];
    cell.diaryBottomEndMonth.text       = [DateSource convertWithDate:diaryData.diaryEndDate format:@"~MMMM dd일"];
    cell.inDiaryCountLabel.text         = [NSString stringWithFormat:@"%ld", [diaryData.inDiaryArray count]];
    
    return cell;
}

/* Tableview didSelectRowAtIndexPath */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /* diary detail segue
     [self performSegueWithIdentifier:@"DiaryDetailSegue" sender:indexPath];
     */
    
    /* in diary list segue */
    [self performSegueWithIdentifier:@"InDiaryListSegue" sender:indexPath];
}

/* Tableview heightForRowAtIndexPath */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (self.view.frame.size.width * 0.75);
}


/* Tableview viewForHeaderInSection */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    RCDiaryTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCDiaryTableViewHeaderView"];
    
    [headerView.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.memberInfo.profileImageURL]
                                placeholderImage:[UIImage imageNamed:@"RCSignInUpTopImage"]];
    
    headerView.profileUserNameLabel.text     = self.memberInfo.nickName;
    headerView.profileUserLocationLabel.text = self.memberInfo.homeTown;
    headerView.profileUserDescription.text   = self.memberInfo.introduction;
    
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
//        footerNibIdentifier = @"RCDiaryTableViewFooterEmptyView";
        footerNibIdentifier = @"RCDiaryTableViewFooterView";
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
    
    return 70;
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchKeywork = [NSString stringWithFormat:@"diaryName CONTAINS[c] '%@'", searchBar.text];
    self.manager.diaryResults = [[RCDiaryRealm allObjects] objectsWhere:searchKeywork];
    
    [self.diaryTableView reloadData];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchKeywork = [NSString stringWithFormat:@"diaryName CONTAINS[c] ''"];
    self.manager.diaryResults = [[RCDiaryRealm allObjects] objectsWhere:searchKeywork];
    
    [self.diaryTableView reloadData];
    
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

#pragma mark - Manual segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"DiaryDetailSegue"]) {
        
        UINavigationController *diaryNaviVC = [segue destinationViewController];
        
        RCDiaryDetailViewController *diaryDetailVC = ((RCDiaryDetailViewController *)diaryNaviVC.topViewController);
        
        RCDiaryRealm *diaryRealm = [self.manager.diaryResults objectAtIndex:((NSIndexPath *)sender).row];
        diaryDetailVC.diaryRealm = diaryRealm;
        
    } else if([segue.identifier isEqualToString:@"InDiaryListSegue"]) {
        
        RCInDiaryListViewController *inDiaryListVC = [segue destinationViewController];
        
        inDiaryListVC.indexPath   = (NSIndexPath *)sender;
        
        self.manager.inDiaryResults = [self.manager.diaryResults objectAtIndex:((NSIndexPath *)sender).row].inDiaryArray;
//        RCDiaryRealm *diaryRealm  = [self.manager.diaryResults objectAtIndex:((NSIndexPath *)sender).row];
//        inDiaryListVC.diaryRealm   = diaryRealm;
    }
}

#pragma mark - RCDiaryTableViewFooter Delegate
- (void)tableViewFooterButton:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"DiaryDetailAddSegue" sender:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView.contentOffset.y < 80) {
        if(self.searchBar.alpha == 0) {
            
            [UIView animateWithDuration:0.6f
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                [self.searchBar setAlpha:1];
//                                [self.diaryTableView setBounces:YES];
                             }
                             completion:nil];
        }
    } else {
        if(self.searchBar.alpha != 0) {
            
            [UIView animateWithDuration:0.6f
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [self.searchBar setAlpha:0];
//                                [self.diaryTableView setBounces:NO];
                             }
                             completion:nil];
        }
    }
}

#pragma mark - Custom Segue
- (IBAction)unwindSegue:(UIStoryboardSegue *)sender {
    
    NSLog(@"unwindSegue");
    
//    [[sender sourceViewController] remove];
    
    // 데이터 변경 완료 시점
    // 조회 or 변경된 데이터를 이 화면에 적용
}

@end
