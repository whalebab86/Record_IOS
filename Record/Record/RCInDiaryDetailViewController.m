//
//  RCInDiaryDetailViewController.m
//  Record
//
//  Created by CLAY on 2017. 4. 7..
//  Copyright © 2017년 whalebab. All rights reserved.
//

/* Record controller import */
#import "RCInDiaryDetailViewController.h"

#import "DateSource.h"

/* library import */
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger, RCInDiaryStatusMode) {
    RCInDiaryStatusModeInsert,
    RCInDiaryStatusModeUpdate
};

@interface RCInDiaryDetailViewController ()
<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryScrollViewBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryPhotoButtonBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDateViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UIDatePicker *inDiaryDatePicker;
@property (weak, nonatomic) IBOutlet UIView *inDiaryPhotoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDeleteViewBottomConstraints;

@property (weak, nonatomic) IBOutlet UIScrollView *inDiaryScrollView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryScrollContentView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryDeleteView;


@property (weak, nonatomic) IBOutlet UILabel *inDiaryLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *inDiaryDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *inDiaryContentTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *inDiaryCollectionView;

@property (nonatomic) RCInDiaryStatusMode inDiaryStatusMode;

@end

@implementation RCInDiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.inDiaryDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    [self.inDiaryPhotoView.layer setCornerRadius:3];
    [self.inDiaryPhotoView setClipsToBounds:YES];
    
    [self.inDiaryDeleteView.layer setCornerRadius:self.inDiaryDeleteView.frame.size.height/2.0f];
    [self.inDiaryDeleteView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.inDiaryDeleteView.layer setBorderWidth:2.0f];
    [self.inDiaryDeleteView setClipsToBounds:YES];
    
    /* keyboard notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardPosition:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardPosition:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
    if(self.inDiaryData == nil) {
        
        /* page status insert */
        self.inDiaryStatusMode = RCInDiaryStatusModeInsert;
        self.inDiaryDatePicker.date = [NSDate date];
        
        self.inDiaryLocationLabel.text = @"current location";
        self.inDiaryDateLabel.text     = [DateSource convertDateToString:self.inDiaryDatePicker.date];
        
        [self.inDiaryDeleteView setHidden:YES];
        
    } else {
       
        /* page status update */
        self.inDiaryStatusMode = RCInDiaryStatusModeUpdate;
        
        self.inDiaryLocationLabel.text   = @"modify location";
        
        self.inDiaryDatePicker.date      = [DateSource convertStringToDate:self.inDiaryData.inDiaryWriteDate];
        self.inDiaryDateLabel.text       = self.inDiaryData.inDiaryWriteDate;
        
        self.inDiaryContentTextView.text = self.inDiaryData.inDiaryContent;

//        [self.diaryCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.diaryData.diaryCoverImageUrl]
//                                    placeholderImage:[UIImage imageNamed:@"RCSignInUpTopImage"]];
    }
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger itemCount = [self.inDiaryData.inDiaryCoverImgUrl count];
    
    if(itemCount == 0) {
        [self.inDiaryCollectionView setHidden:YES];
    }
    
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCInDiaryListViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *imageUrl = [self.inDiaryData.inDiaryCoverImgUrl objectAtIndex:indexPath.row];
    
    [cell.inDiaryCollectionImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                       placeholderImage:[UIImage imageNamed:@"RCSignInUpTopImage"]];
    
    return cell;
}

#pragma mark - Custom button click Method
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.6 animations:^{
        
        if(self.inDiaryDateViewHeightConstraints.constant != 60) {
            
            self.inDiaryDateViewHeightConstraints.constant = 60;
            self.inDiaryDatePicker.alpha = 0;
        }
        
        [self.view layoutIfNeeded];
    }];
    
    return YES;
}


#pragma mark - Custom button click Method
- (IBAction)clickLocationButton:(id)sender {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        if(self.inDiaryDateViewHeightConstraints.constant == 60) {
            
            self.inDiaryDateViewHeightConstraints.constant += self.inDiaryDatePicker.frame.size.height;
            self.inDiaryDatePicker.alpha = 1;
        } else {
            
            self.inDiaryDateViewHeightConstraints.constant = 60;
            self.inDiaryDatePicker.alpha = 0;
        }
        
        [self.view layoutIfNeeded];
    }];
    
}
- (IBAction)changeInDiaryDatePicker:(UIDatePicker *)sender forEvent:(UIEvent *)event {
    
    self.inDiaryDateLabel.text = [DateSource convertDateToString:sender.date];
}


- (IBAction)clickCancelBarButton:(id)sender {
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapInDiaryScrollView:(UIGestureRecognizer *)sender {
    
    if(!self.inDiaryContentTextView.isFirstResponder) {
        [self.inDiaryContentTextView becomeFirstResponder];
    } else {
        [self.inDiaryContentTextView resignFirstResponder];
    }
    
    NSLog(@"Tap");
}


#pragma mark - Custom notification Method
/* Notification show & hide method */
- (void)didChangeKeyboardPosition:(NSNotification *)notification {
    
    CGRect keyboardInfo = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat bottomConstant = self.inDiaryScrollViewBottomConstraints.constant;
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification] && bottomConstant == 0) {
        
        CGFloat scrollViewBottom = 0;
        
        if(self.inDiaryStatusMode == RCInDiaryStatusModeInsert) {
            scrollViewBottom  = 50;
        } else {
            scrollViewBottom  = 110;
        }
        
        self.inDiaryScrollViewBottomConstraints.constant += (keyboardInfo.size.height + scrollViewBottom);
        self.inDiaryPhotoButtonBottomConstraints.constant = (keyboardInfo.size.height + 5);
        self.inDiaryDeleteViewBottomConstraints.constant  = (keyboardInfo.size.height + 5);
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]  && bottomConstant != 0) {
        
        self.inDiaryScrollViewBottomConstraints.constant  = 0;
        self.inDiaryPhotoButtonBottomConstraints.constant = 10;
        self.inDiaryDeleteViewBottomConstraints.constant  = 10;
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)tapScrollView:(UITapGestureRecognizer *)sender {
    
    if(self.inDiaryContentTextView.isFirstResponder) {
        
//        [self.inDiaryContentTextView resignFirstResponder];
    }
}

@end


@implementation RCInDiaryListViewCollectionViewCell

@end



