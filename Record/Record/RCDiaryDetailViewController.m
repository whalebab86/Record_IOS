//
//  RCDiaryDetailViewController.m
//  Record
//
//  Created by CLAY on 2017. 3. 28..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCDiaryDetailViewController.h"
#import "RCDiaryListViewController.h"

#import "DateSource.h"


@interface RCDiaryDetailViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView  *diaryCoverImageView;
@property (weak, nonatomic) IBOutlet UIButton     *diaryCoverButton;
@property (weak, nonatomic) IBOutlet UILabel      *diaryPrivateSettingLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *diaryKeyboardDatePicker;

@property (weak, nonatomic) IBOutlet UITextField  *diaryNameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *diaryStartDateTextField;
@property (weak, nonatomic) IBOutlet UITextField  *diaryEndDateTextField;


@property (weak, nonatomic) IBOutlet UIView      *diaryDeleteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diaryDeleteViewBottomConstraints;

@property (nonatomic) UIImagePickerControllerSourceType diaryImagePickerControllerSourceType;

@end

@implementation RCDiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
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
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(clickDiaryKeyboardDoneButton:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/* imagepicker controller cancel */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
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

#pragma mark - Custom Method

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

/* Notification show & hide method */
- (IBAction)clickDiaryDoneButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Diary keyboard done button click method*/
- (void)clickDiaryKeyboardDoneButton:(id)sender{
    
    
    if(self.diaryStartDateTextField.isFirstResponder) {
        
        self.diaryStartDateTextField.text = [DateSource dateFormatWithDate:self.diaryKeyboardDatePicker.date];
        
    } else if(self.diaryEndDateTextField.isFirstResponder) {
        
        self.diaryEndDateTextField.text = [DateSource dateFormatWithDate:self.diaryKeyboardDatePicker.date];
        
    }
    
    if([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        [self.diaryStartDateTextField endEditing:YES];
        [self.diaryEndDateTextField   endEditing:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

/* Notification show & hide method */
- (void)didChangeKeyboardPosition:(NSNotification *)notification {

    CGRect keyboardInfo = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        self.diaryDeleteViewBottomConstraints.constant += keyboardInfo.size.height;
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        self.diaryDeleteViewBottomConstraints.constant -= keyboardInfo.size.height;
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
  
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
