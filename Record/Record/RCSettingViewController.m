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


@interface RCSettingViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingMainTableView;
@property (nonatomic) RCSettingTableInfo *settingTableInfo;

@end

@implementation RCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    RCSettingTableInfo *settingTableInfo = [[RCSettingTableInfo alloc] init];
    self.settingTableInfo = settingTableInfo;
    
    self.settingMainTableView.delegate = self;
    self.settingMainTableView.dataSource = self;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingTableInfo.sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.settingTableInfo.sectionTitleArray[0];
            break;
            
        case 1:
            return self.settingTableInfo.sectionTitleArray[1];
            
        default:
            return @"";
            break;
            
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.settingTableInfo.accountSectionRowCount;
            break;
            
        case 1:
            return self.settingTableInfo.supportSectionRowCount;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    NSString *reuseCellID = @"RCSettingTableViewCell";
    RCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.settingTableInfo.accountSectionTitleArray[indexPath.row];
            return cell;
            break;
            
        case 1:
            cell.textLabel.text = self.settingTableInfo.sectionTitleArray[indexPath.row];
            return cell;
        default:
            return nil;
            break;
    }
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
