//
//  RCIndicatorUtil.h
//  Record
//
//  Created by CLAY on 2017. 4. 21..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RCIndicatorUtil : NSObject

- (instancetype)initWithTargetView:(UIView *) view isMask:(BOOL) mask;
- (void)startIndicator;
- (void)stopIndicator;

@end
