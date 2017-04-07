//
//  RCInDiaryDetailViewController.m
//  Record
//
//  Created by CLAY on 2017. 4. 7..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryDetailViewController.h"

@interface RCInDiaryDetailViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryScrollViewBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryPhotoButtonBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDateViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UIDatePicker *inDiaryDatePicker;
@property (weak, nonatomic) IBOutlet UIView *inDiaryPhotoView;

@end

@implementation RCInDiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
//    datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
    
    [self.inDiaryDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    [self.inDiaryPhotoView.layer setCornerRadius:3];
    [self.inDiaryPhotoView setClipsToBounds:YES];
    
    /* keyboard notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardPosition:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardPosition:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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

- (IBAction)clickCancelBarButton:(id)sender {
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Custom notification Method
/* Notification show & hide method */
- (void)didChangeKeyboardPosition:(NSNotification *)notification {
    
    CGRect keyboardInfo = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat bottomConstant = self.inDiaryScrollViewBottomConstraints.constant;
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification] && bottomConstant == 0) {
        
        self.inDiaryScrollViewBottomConstraints.constant += (keyboardInfo.size.height + 50);
        self.inDiaryPhotoButtonBottomConstraints.constant = (keyboardInfo.size.height + 5);
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]  && bottomConstant != 0) {
        
        self.inDiaryScrollViewBottomConstraints.constant  = 0;
        self.inDiaryPhotoButtonBottomConstraints.constant = 10;
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

@end
