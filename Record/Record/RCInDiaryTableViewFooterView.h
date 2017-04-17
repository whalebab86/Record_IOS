//
//  RCInDiaryTableViewFooter.h
//  Record
//
//  Created by CLAY on 2017. 4. 14..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCInDiaryTableViewFooterDelegate <NSObject>

- (void)tableViewFooterButton:(UIButton *)button;

@end

@interface RCInDiaryTableViewFooterView : UITableViewHeaderFooterView

@property (nonatomic) id<RCInDiaryTableViewFooterDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *bottomEndDayLabel;

@end
