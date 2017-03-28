//
//  RCDiaryTableViewFooterView.h
//  Record
//
//  Created by CLAY on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCDiaryTableViewFooterDelegate <NSObject>

- tableViewFooterButton:(UIButton *)button;

@end

@interface RCDiaryTableViewFooterView : UITableViewHeaderFooterView

@property id<RCDiaryTableViewFooterDelegate> delegate;

@end
