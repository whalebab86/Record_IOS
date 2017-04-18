//
//  RCDiaryDetailViewController.m
//  Record
//
//  Created by CLAY on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

/* Record controller import */
#import "RCDiaryDetailViewController.h"
#import "RCDiaryListViewController.h"

/* Record source import */
#import "RCDiaryManager.h"
#import "DateSource.h"

/* library import */
#import <Realm.h>
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger, RCDiaryStatusMode) {
    RCDiaryStatusModeInsert,
    RCDiaryStatusModeUpdate
};

@interface RCDiaryDetailViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView  *diaryCoverImageView;
@property (weak, nonatomic) IBOutlet UIButton     *diaryCoverButton;
@property (weak, nonatomic) IBOutlet UILabel      *diaryPrivateSettingLabel;

@property (weak, nonatomic) IBOutlet UITextField  *diaryNameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *diaryStartDateTextField;
@property (weak, nonatomic) IBOutlet UITextField  *diaryEndDateTextField;

@property (weak, nonatomic) IBOutlet UIView       *diaryDeleteView;

@property (nonatomic)       UIImagePickerControllerSourceType diaryImagePickerControllerSourceType;

@property (weak, nonatomic) UIDatePicker                     *diaryKeyboardDatePicker;
@property (nonatomic)       RCDiaryStatusMode                 diaryModifyMode;

@property (weak, nonatomic) IBOutlet UIView *diaryMaskView;

/* diary delete view constraint */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diaryDeleteViewBottomConstraints;

/* diary stack view top constraint */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diaryStackViewTopConstraint;

@property (nonatomic) NSDate *diaryStartDate;
@property (nonatomic) NSDate *diaryEndDate;
@property (nonatomic) NSData *diaryCoverImg;

@property (nonatomic, weak) UIDatePicker *diaryDatePicker;

@property (nonatomic) RCDiaryManager *manager;

@end

@implementation RCDiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.manager    = [RCDiaryManager diaryManager];
    
    if(self.indexPath != nil) {
        self.diaryRealm = [self.manager.diaryResults objectAtIndex:self.indexPath.row];
    }
    
    if(self.diaryRealm == nil) {
//    if(self.diaryData == nil) {
    
        self.diaryModifyMode = RCDiaryStatusModeInsert;
        
        self.diaryRealm = [[RCDiaryRealm alloc] init];
        
        self.diaryCoverImg = UIImagePNGRepresentation([UIImage imageNamed:@"RCSignInUpTopImage"]);
        /* page status insert
        self.diaryData = [[RCDiaryData alloc] init];
        
        [self.diaryDeleteView setHidden:YES];
         */
    } else {
        
        self.diaryModifyMode = RCDiaryStatusModeUpdate;
        /* page status update
        
        self.diaryNameTextField.text      = self.diaryData.diaryName;
        self.diaryStartDateTextField.text = self.diaryData.diaryStartDate;
        self.diaryEndDateTextField.text   = self.diaryData.diaryEndDate;
        
        [self.diaryCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.diaryData.diaryCoverImageUrl]
                                    placeholderImage:[UIImage imageNamed:@"RCSignInUpTopImage"]];
         */
        
        self.diaryCoverImageView.image    = [UIImage imageWithData:self.diaryRealm.diaryCoverImage];
        self.diaryNameTextField.text      = self.diaryRealm.diaryName;
        self.diaryStartDateTextField.text = [DateSource convertWithDate:self.diaryRealm.diaryStartDate format:@"yyyy-MM-dd"];
        self.diaryEndDateTextField.text   = [DateSource convertWithDate:self.diaryRealm.diaryEndDate   format:@"yyyy-MM-dd"];
        
        self.diaryStartDate = self.diaryRealm.diaryStartDate;
        self.diaryEndDate   = self.diaryRealm.diaryEndDate;
        self.diaryCoverImg  = self.diaryRealm.diaryCoverImage;
    }
    
    /* diary cover imageview custom */
    [self.diaryCoverImageView.layer setCornerRadius:(self.diaryCoverImageView.frame.size.height / 2.0f)];
    [self.diaryCoverImageView       setClipsToBounds:YES];
    
    /* diary cover button custom */
    [self.diaryCoverButton.layer setCornerRadius:5];
    [self.diaryCoverButton.layer setBorderWidth:1];
    [self.diaryCoverButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    /* diary delete view custom */
    [self.diaryDeleteView.layer setBorderWidth:1];
    [self.diaryDeleteView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.diaryDeleteView.layer setCornerRadius:(self.diaryDeleteView.frame.size.height / 2.0f)];
    [self.diaryDeleteView       setClipsToBounds:YES];
        
    /* keyboard notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardPosition:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeKeyboardPosition:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    /* Textfield Placeholder font color custom */
    UIColor *color = [UIColor lightTextColor];
    self.diaryNameTextField.attributedPlaceholder      = [[NSAttributedString alloc] initWithString:@"Diary name"
                                                                                         attributes:@{NSForegroundColorAttributeName: color}];
    self.diaryStartDateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Diary start date"
                                                                                         attributes:@{NSForegroundColorAttributeName: color}];
    self.diaryEndDateTextField.attributedPlaceholder   = [[NSAttributedString alloc] initWithString:@"Diary end date"
                                                                                         attributes:@{NSForegroundColorAttributeName: color}];

    /* Textfield datepicker custom */
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(clickDiaryKeyboardDoneButton:) forControlEvents:UIControlEventValueChanged];
    
    self.diaryDatePicker = datePicker;
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                        target:self action:@selector(clickDiaryKeyboardDoneButton:)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(clickDiaryKeyboardDoneButton:)];
    
    keyboardToolbar.items = @[cancelBarButton, flexBarButton, doneBarButton];
    
    [self.diaryStartDateTextField setInputView:datePicker];
    [self.diaryEndDateTextField   setInputView:datePicker];
    
    [self.diaryStartDateTextField setInputAccessoryView:keyboardToolbar];
    [self.diaryEndDateTextField   setInputAccessoryView:keyboardToolbar];
    
    self.diaryKeyboardDatePicker = datePicker;
}

#pragma mark - UIImagePickerController Delegate

/* imagepicker controller finish */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *takenImage, *imageToSave;
    
    takenImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(!takenImage)
        takenImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    
    imageToSave = takenImage;
    
    if (self.diaryImagePickerControllerSourceType == UIImagePickerControllerSourceTypeCamera) {
        
        /* Image picker controller source type camera  */
        /* 카메라로 촬영시만 해당 이미지를 포토 엘범에 저장 */
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    } else if (self.diaryImagePickerControllerSourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        /* Image picker controller source type photo */
    }
    
    self.diaryCoverImageView.image = takenImage;
    
//    self.diaryCoverImg = UIImagePNGRepresentation(takenImage);
    self.diaryCoverImg = UIImageJPEGRepresentation(takenImage, 0.6);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/* imagepicker controller cancel */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == self.diaryStartDateTextField) {
        
        self.diaryDatePicker.date = [DateSource convertStringToDate:textField.text];
    } else if(textField == self.diaryEndDateTextField) {
        
        self.diaryDatePicker.date = [DateSource convertStringToDate:textField.text];
    }
    
    return YES;
}

/* textField should return delegate */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:self.diaryNameTextField]) {
        
        [textField resignFirstResponder];
//        [self.diaryStartDateTextField becomeFirstResponder];
    } else if([textField isEqual:self.diaryStartDateTextField]) {
        
        [textField resignFirstResponder];
//        [self.diaryEndDateTextField becomeFirstResponder];
    } else if([textField isEqual:self.diaryEndDateTextField]) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - UIScrollview Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
}

#pragma mark - Custom button click Method
/* Diary cover button click method*/
- (IBAction)clickDiaryCoverButton:(UIButton *)sender {
    
    UIAlertController *coverAlert = [UIAlertController alertControllerWithTitle:@"Diary cover image"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    /* Camera action - 카메라가 존재하는 기기에서만 사용 */
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                                                                 cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 cameraPicker.delegate   = self;
                                                                 
                                                                 self.diaryImagePickerControllerSourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 
                                                                 [self presentViewController:cameraPicker animated:YES completion:nil];
                                                             }];
        [coverAlert addAction:cameraAction];
    }
    
    /* Photo action */
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Photo"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                                                             cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             cameraPicker.delegate   = self;
                                                             
                                                             self.diaryImagePickerControllerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             
                                                             [self presentViewController:cameraPicker animated:YES completion:nil];
                                                         }];
    [coverAlert addAction:photoAction];
    
    /* Cancel action */
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [coverAlert addAction:cancelAction];
    
    [self presentViewController:coverAlert animated:YES completion:nil];
    
}

/* Diary private setting button click method*/
- (IBAction)clickDiaryPrivateSettingButton:(UIButton *)sender {
    
    UIAlertController *privateSettingAction = [UIAlertController alertControllerWithTitle:@"Diary private setting"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    /* onlyMe action */
    UIAlertAction *onlyMeAction = [UIAlertAction actionWithTitle:@"Only me"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             self.diaryPrivateSettingLabel.text = @"Only me";
                                                         }];
    [privateSettingAction addAction:onlyMeAction];
    
    
    /* myFollowers action */
    UIAlertAction *myFollowersAction = [UIAlertAction actionWithTitle:@"My followers"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             self.diaryPrivateSettingLabel.text = @"My followers";
                                                         }];
    [privateSettingAction addAction:myFollowersAction];
    
    /* everyone action */
    UIAlertAction *everyoneAction = [UIAlertAction actionWithTitle:@"Everyone"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             self.diaryPrivateSettingLabel.text = @"Everyone";
                                                         }];
    [privateSettingAction addAction:everyoneAction];
    
    
    /* Cancel action */
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [privateSettingAction addAction:cancelAction];
    
    [self presentViewController:privateSettingAction animated:YES completion:nil];
}
- (IBAction)clickDiaryCancelButton:(id)sender {
    
    if(self.diaryModifyMode == RCDiaryStatusModeInsert) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if(self.diaryModifyMode == RCDiaryStatusModeUpdate) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/* Diary done button click method */
- (IBAction)clickDiaryDoneButton:(UIBarButtonItem *)sender {
    
    /* diary data setting */
    if(![self settingDiaryDataInfo]) {
        NSLog(@"fail");
        return;
    };
    
    if(self.diaryModifyMode == RCDiaryStatusModeInsert) {
        /* page insert mode */
        
        [self.manager.realm transactionWithBlock:^{
            
            self.diaryRealm.diaryPk         = [DateSource convertWithDate:[NSDate date] format:@"yyyyMMddHHmmssSSSS"];
            self.diaryRealm.diaryName       = self.diaryNameTextField.text;
            self.diaryRealm.diaryStartDate  = self.diaryStartDate;
            self.diaryRealm.diaryEndDate    = self.diaryEndDate;
            self.diaryRealm.diaryCoverImage = self.diaryCoverImg;
            self.diaryRealm.diaryCreateDate = [NSDate date];
            
            [self.manager.realm addOrUpdateObject:self.diaryRealm];
            
            [self.view endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
//        [[RCDiaryManager diaryManager] insertDiaryItemwithDiaryObject:self.diaryData];
//        
//        [[RCDiaryManager diaryManager] requestDiaryInsertWithCompletionHandler:^(BOOL isSuccess, id responseData) {
//            
//            if(isSuccess) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                   [self dismissViewControllerAnimated:YES completion:nil];
//                });
//            } else {
//                
//                NSLog(@"fail");
//            }
//        }];
        
    } else if(self.diaryModifyMode == RCDiaryStatusModeUpdate) {
        /* page update mode */
        
        [self.view endEditing:YES];
        
        [self.manager.realm transactionWithBlock:^{
            
            self.diaryRealm.diaryCoverImage = self.diaryCoverImg;
            
            self.diaryRealm.diaryName      = self.diaryNameTextField.text;
            self.diaryRealm.diaryStartDate = self.diaryStartDate;
            self.diaryRealm.diaryEndDate   = self.diaryEndDate;
            
            [self.manager.realm addOrUpdateObject:self.diaryRealm];
            
            [self performSegueWithIdentifier:@"InDiaryListUnwindSegue" sender:self];
        }];
        
//        [[RCDiaryManager diaryManager] updateDiaryItemAtIndexPaths:self.indexPath withDiaryObject:self.diaryData];
//        
//        [[RCDiaryManager diaryManager] requestDiaryUpdateWithCompletionHandler:^(BOOL isSuccess, id responseData) {
//            
//            if(isSuccess) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                    [self performSegueWithIdentifier:@"InDiaryUnwindSegue" sender:self];
//                });
//            } else {
//                
//                NSLog(@"fail");
//            }
//        }];
    }
}


/* Diary keyboard done button click method*/
- (void)clickDiaryKeyboardDoneButton:(id)sender{
    
    
    if([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        if(((UIBarButtonItem *)sender).style == UIBarButtonItemStylePlain) {
            
            if(self.diaryStartDateTextField.isFirstResponder) {
                
                [self.diaryStartDateTextField setText:@""];
                [self.diaryStartDateTextField resignFirstResponder];
                
            } else if(self.diaryEndDateTextField.isFirstResponder) {
                
                [self.diaryEndDateTextField setText:@""];
                [self.diaryEndDateTextField resignFirstResponder];
            }
        } else if(((UIBarButtonItem *)sender).style == UIBarButtonItemStyleDone){
            
            [self settingDateInfoIsEnd:YES];
        }
        
    } else {
        
        [self settingDateInfoIsEnd:NO];
    }
}


- (IBAction)clickDiaryDeleteButton:(UIButton *)sender {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        
        [realm deleteObject:self.diaryRealm];
        //[realm addOrUpdateObject:self.diaryRealm];
        
        [self.view endEditing:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"InDiaryUnwindSegue" sender:self];
    }];
    
//    [[RCDiaryManager diaryManager] deleteDiaryItemAtIndexPaths:self.indexPath];
//    
//    [[RCDiaryManager diaryManager] requestDiaryDeleteWithCompletionHandler:^(BOOL isSuccess, id responseData) {
//        
//        if(isSuccess) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        } else {
//            
//            NSLog(@"fail");
//        }
//    }];
    
}


#pragma mark - Custom method

- (void)settingDateInfoIsEnd:(BOOL)result {
    
    if(self.diaryStartDateTextField.isFirstResponder) {
        
        self.diaryStartDateTextField.text = [DateSource convertDateToString:self.diaryKeyboardDatePicker.date];
        self.diaryStartDate = self.diaryKeyboardDatePicker.date;
        
//        self.diaryRealm.diaryStartDate = self.diaryKeyboardDatePicker.date;
        
        if(result) [self.diaryStartDateTextField resignFirstResponder];
        //        if(result)  [self.diaryEndDateTextField becomeFirstResponder];
        
    } else if(self.diaryEndDateTextField.isFirstResponder) {
        
        self.diaryEndDateTextField.text = [DateSource convertDateToString:self.diaryKeyboardDatePicker.date];
        self.diaryEndDate   = self.diaryKeyboardDatePicker.date;
//        self.diaryRealm.diaryEndDate = self.diaryKeyboardDatePicker.date;
        
        if(result) [self.diaryEndDateTextField resignFirstResponder];
        
        //        if(result)  [self.diaryEndDateTextField resignFirstResponder];
    }
}


- (BOOL)settingDiaryDataInfo {
    
    NSString *msg = @"";
    BOOL result = NO;
    
    NSComparisonResult dateCompareResult = [DateSource comparWithFromDate:self.diaryStartDate
                                                               withToDate:self.diaryEndDate];
    
    /* 공백 제거 */
    NSString *diaryName = [self.diaryNameTextField.text
                           stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if([diaryName isEqualToString:@""]) {
        
        msg = @"Diary name is empty";
    } else if([self.diaryStartDateTextField.text isEqualToString:@""]) {
        
        msg = @"Diary start date is empty";
    } else if([self.diaryEndDateTextField.text isEqualToString:@""]) {
        
        msg = @"Diary end date is empty";
    } else if(dateCompareResult == NSOrderedDescending) {
        
        msg = @"Diary date error";
    } else {
        
        result = YES;
    }
    
    if(result) {
        
//        self.diaryData.diaryName          = self.diaryNameTextField.text;
//        self.diaryData.diaryStartDate     = self.diaryStartDateTextField.text;
//        self.diaryData.diaryEndDate       = self.diaryEndDateTextField.text;
//        self.diaryData.diaryCoverImageUrl = @"";
//        self.diaryData.inDiaryCount       = 0;
        
    } else {
        
        /* vaildate alert */
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    return result;
}


#pragma mark - Custom segue Method
/* */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Custom notification Method
/* Notification show & hide method */
- (void)didChangeKeyboardPosition:(NSNotification *)notification {

    CGRect keyboardInfo = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat topConstant = self.diaryDeleteViewBottomConstraints.constant;
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification] && topConstant == 8) {
        
        self.diaryDeleteViewBottomConstraints.constant += (keyboardInfo.size.height - 45);
        self.diaryStackViewTopConstraint.constant = -100;
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]  && topConstant != 8) {
        
        self.diaryMaskView.alpha = 0;
        self.diaryDeleteViewBottomConstraints.constant = 8;
        self.diaryStackViewTopConstraint.constant = 0;
        
    }
    
    /*  */
    if([notification.name isEqualToString:UIKeyboardWillShowNotification] && ![self.diaryNameTextField isFirstResponder]) {
        self.diaryMaskView.alpha = 0.4;
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
