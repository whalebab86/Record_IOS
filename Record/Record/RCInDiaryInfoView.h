//
//  RCInDiaryInfoView.h
//  Record
//
//  Created by CLAY on 2017. 4. 21..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCInDiaryInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *inDiaryCoverImageView;

@property (weak, nonatomic) IBOutlet UILabel     *inDiaryLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *inDiaryDaysLabel;
@property (weak, nonatomic) IBOutlet UITextView  *inDiaryContentLabel;

@end
