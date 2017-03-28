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

@interface RCDiaryListViewController ()
<UITableViewDataSource, UITableViewDelegate, RCDiaryTableViewFooterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *DiaryTableView;

@end

@implementation RCDiaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


#pragma mark - TableView DataSource
#pragma mark - TableView Delegate
/* Tableview numberOfRowsInSection */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


/* Tableview cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell" forIndexPath:indexPath];
    
    
    return cell;
}

/* Tableview viewForHeaderInSection */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UINib *nib = [UINib nibWithNibName:@"RCDiaryTableViewHeaderView" bundle: nil];
    [self.DiaryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"RCDiaryTableViewHeaderView"];
    
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
    
    UINib *nib = [UINib nibWithNibName:footerNibIdentifier bundle: nil];
    [self.DiaryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:footerNibIdentifier];
    
    RCDiaryTableViewFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerNibIdentifier];
    
    [footerView setDelegate:self];
    
    return footerView;
}

/* Tableview heightForFooterInSection */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 80;
}

#pragma mark - RCDiaryTableViewFooter Delegate
-(void)didClickAddButton {
    
    NSLog(@"Click Add Button");
}

#pragma mark - Custom method


@end
