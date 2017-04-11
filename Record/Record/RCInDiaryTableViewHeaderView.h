//
//  RCInDiaryTableViewHeaderView.h
//  Record
//
//  Created by CLAY on 2017. 4. 3..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCInDiaryTableViewHeaderDelegate <NSObject>

- (void)showInDiaryLocationView;

@end

@interface RCInDiaryTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic) id<RCInDiaryTableViewHeaderDelegate> delegate;

@end
