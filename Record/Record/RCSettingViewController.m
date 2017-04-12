//
//  RCSettingViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 29..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCSettingViewController.h"
#import "RCSettingTableInfo.h"
#import "RCSettingTableViewCell.h"
#import "RCSettingHeaderView.h"
#import "RCProfileViewController.h"
#import "RCLoginManager.h"
@import GooglePlaces;

@interface RCSettingViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingMainTableView;
@property (nonatomic) RCSettingTableInfo *settingTableInfo;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;


@end

@implementation RCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    RCSettingTableInfo *settingTableInfo = [[RCSettingTableInfo alloc] init];
    self.settingTableInfo = settingTableInfo;
    
    self.settingMainTableView.delegate = self;
    self.settingMainTableView.dataSource = self;
    
    UINib *headerNib = [UINib nibWithNibName:@"RCSettingHeaderView" bundle:[NSBundle mainBundle]];
    [self.settingMainTableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"RCSettingHeaderView"];
    
    self.logoutButton.layer.cornerRadius = 3.0f;
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:197/255.0f green:208/255.0f blue:222/255.0f alpha:1.0f].CGColor;

}

#pragma mark - main tableview datasource
/* tableView section setting */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingTableInfo.sectionCount;
}

/* tableview number of rows in section setting */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.settingTableInfo.accountSectionRowCount;
            break;
            
        case 1:
            return self.settingTableInfo.supportSectionRowCount;
            
        default:
            return 1;
            break;
    }
}

/* insert parameter into cell */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCSettingTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.settingCellTitleLB.text = self.settingTableInfo.accountSectionTitleArray[indexPath.row];
            return cell;
            break;
            
        case 1:
            cell.settingCellTitleLB.text = self.settingTableInfo.supportSectionTitleArray[indexPath.row];
            return cell;
        default:
            return nil;
            break;
    }
}


#pragma mark - main tableview delegate
/* height for header in section setting */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

/* custom header in section */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RCSettingHeaderView *headerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RCSettingHeaderView"];
    if (section == 0 ) {
        headerView.sectionHeaderTitle.text = self.settingTableInfo.sectionTitleArray[section];
        return headerView;
    } else {
        headerView.sectionHeaderTitle.text = self.settingTableInfo.sectionTitleArray[section];
        return headerView;
    }
}

/* If select tableview row, views transrate page that connected segue. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"ProfileChangeSegue" sender:tableView];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"SupportContentSegue" sender:tableView];
        }
    }
}

#pragma mark - logout action
/* log out */
- (IBAction)logoutButtonAction:(UIButton *)sender {
    
    NSLog(@"logoutButtonAction");
    [[RCLoginManager loginManager] logoutWithComplition:^(BOOL isSucceess, NSInteger code) {
        if (isSucceess) {
            NSLog(@"logout success");
//            [self performSegueWithIdentifier:@"MemberSegueFromSetting" sender:nil];
//            [self.navigationController performSegueWithIdentifier:@"RecordLoginSegue" sender:self];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"logout error");
        }
    }];
    
}
- (IBAction)cancelBarButtonItemAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - etc
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
