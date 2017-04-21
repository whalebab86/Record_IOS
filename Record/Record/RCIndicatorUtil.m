//
//  RCIndicatorUtil.m
//  Record
//
//  Created by CLAY on 2017. 4. 21..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCIndicatorUtil.h"
#import "DGActivityIndicatorView.h"

@interface RCIndicatorUtil ()

@property (nonatomic) DGActivityIndicatorView *indicatorView;
@property (nonatomic) UIView *mainView;

@end

@implementation RCIndicatorUtil

- (instancetype)initWithTargetView:(UIView *) view isMask:(BOOL) mask
{
    self = [super init];
    
    if (self) {
        
        /* indicator */
        DGActivityIndicatorView *indicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeNineDots
                                                                                 tintColor:[UIColor whiteColor]
                                                                                      size:40.0f];

        
        self.mainView = [[UIView alloc] init];
        
        if(mask) {
            [self.mainView setFrame:view.frame];
        } else {
            [self.mainView setFrame:indicator.frame];
        }
        
        [self.mainView setBackgroundColor:[UIColor lightGrayColor]];
        [self.mainView setAlpha:0];
        self.indicatorView = indicator;
        self.indicatorView.frame = view.frame;
        
        
        self.indicatorView.center = view.center;
        
        [self.mainView addSubview:self.indicatorView];
        
        [view addSubview:self.mainView];
    }
    return self;
}

- (void)startIndicator {
    
    [self.mainView setAlpha:0.4];
    [self.indicatorView startAnimating];
}

- (void)stopIndicator {
    
    [self.mainView setAlpha:0];
    [self.indicatorView stopAnimating];
}

@end
