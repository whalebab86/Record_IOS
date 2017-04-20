//
//  RCDiaryTableViewHeaderView.h
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDiaryTableViewHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel     *profileUserDescription;

- (void)showGoogleMap;

@end
