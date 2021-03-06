//
//  RCProfileViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 4..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RCProfileViewController.h"
#import "RCLoginManager.h"
#import "RCMemberInfo.h"
#import "RCIndicatorUtil.h"

@import GooglePlaces;
@import GooglePlacePicker;

@interface RCProfileViewController ()
<UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *homTownLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedPlaceButton;
@property (weak, nonatomic) IBOutlet UITextView *shortStoryTextView;
@property (weak, nonatomic) IBOutlet UILabel *textViewplaceHolderLB;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarBtnInNavi;
@property (weak, nonatomic) UIButton *doneButtonInKeyboard;
@property (weak, nonatomic) UILabel *countCharcterLabelInKeyboard;

@property (nonatomic) GMSPlacesClient *placesClient;
@property (weak, nonatomic) IBOutlet UIButton *googleCurrentPlaceBtn;

@property GMSPlacePicker *placePicker;

@property CLLocationManager *locationManiger;
@property (weak, nonatomic) IBOutlet UIButton *saveProfileButtonFromMemberStoryboard;

@end

@implementation RCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //clip to bounds?
    self.profileImage.layer.cornerRadius = 40.0f;
    
    /* text field delegate */
    self.nickNameTextField.delegate = self;
    
    /* text view delegate */
    self.shortStoryTextView.delegate = self;
    
    /* google place */
    self.placesClient = [GMSPlacesClient sharedClient];
    
    /* private location setting */
    self.locationManiger = [[CLLocationManager alloc] init];
    self.locationManiger.delegate = self;
    
    
    /* UIToolbar to input keyboard accessory of textView */
    UIToolbar *keyboardToolBar = [[UIToolbar alloc] init];
    keyboardToolBar.backgroundColor = [UIColor colorWithRed:197/255.0f green:208/255.0f blue:222/255.0f alpha:1.0f];
    [keyboardToolBar sizeToFit];
    
    /* doneButton */
    UIView *doneButtonBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    UIButton *donButtonInKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    donButtonInKeyboard.frame = CGRectMake(0, 0, 50, 20);
    [donButtonInKeyboard setTitle:@"Done" forState:UIControlStateNormal];
    [donButtonInKeyboard setTitleColor:[UIColor colorWithRed:56/255.0f green:61/255.0f blue:73/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [donButtonInKeyboard addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    donButtonInKeyboard.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:17.0f];
    donButtonInKeyboard.layer.borderWidth = 1.0f;
    donButtonInKeyboard.layer.cornerRadius = 3.0f;
    self.doneButtonInKeyboard = donButtonInKeyboard;
    [doneButtonBottomView addSubview:donButtonInKeyboard];
    UIBarButtonItem *doneBarButtonInKeyboard = [[UIBarButtonItem alloc] initWithCustomView:doneButtonBottomView];
    
    /* countCharcterLabel */
    UILabel *countCharcterLabelInKeyboard = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    countCharcterLabelInKeyboard.layer.cornerRadius = 3.0f;
    countCharcterLabelInKeyboard.layer.borderWidth = 1.0f;
    countCharcterLabelInKeyboard.textColor = [UIColor colorWithRed:56/255.0f green:61/255.0f blue:73/255.0f alpha:1.0f];
    countCharcterLabelInKeyboard.textAlignment = NSTextAlignmentCenter;
    countCharcterLabelInKeyboard.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:15.0f];
    countCharcterLabelInKeyboard.text = @"140";
    self.countCharcterLabelInKeyboard = countCharcterLabelInKeyboard;
    UIBarButtonItem *countCharcterBarLabel = [[UIBarButtonItem alloc] initWithCustomView:countCharcterLabelInKeyboard];
    
    /* UIBarButtonSystemItemFlexibleSpace */
    UIBarButtonItem *flexibleBarButtonInKeyboard = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    keyboardToolBar.items = @[flexibleBarButtonInKeyboard, countCharcterBarLabel, doneBarButtonInKeyboard];
    self.shortStoryTextView.inputAccessoryView = keyboardToolBar;
    
    /* keyboard notification */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    /* profile image */
    RCMemberInfo *personalInfo = [[RCMemberInfo alloc] init];
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:personalInfo.profileImageURL] placeholderImage:[UIImage imageNamed:@"RC_profile_placehold_icon"]];
    
    self.nickNameTextField.text = personalInfo.nickName;
    self.homTownLabel.text = personalInfo.homeTown;
    self.shortStoryTextView.text = personalInfo.introduction;
    
    /* text view place holder */
    if([self.shortStoryTextView hasText]) {
        self.textViewplaceHolderLB.hidden = YES;
    }
}

#pragma mark - text field delegate
/*  */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - google place
/* current place */
- (IBAction)googleCurrentPlaceButtonAction:(UIButton *)sender {
    if (sender == self.googleCurrentPlaceBtn) {
        
        RCIndicatorUtil *activityIndicatorView = [[RCIndicatorUtil alloc] initWithTargetView:self.view isMask:YES];
        [activityIndicatorView startIndicator];
        
        [self.locationManiger requestWhenInUseAuthorization];
        [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
            if (error != nil) {
                [self addAlertViewWithTile:@"위치를 가져오지 못하였습니다. 다시한번 실행해 주세요!" actionTitle:@"done" handler:nil];
                return;
            }
            /* 0번째 인덱스에 가까울수록 likelihoods(자신이 현재 있는곳과 가장 비슷함을 나타냄)가 높다 */
            GMSPlace* place = placeLikelihoodList.likelihoods[0].place;
            self.homTownLabel.text = place.formattedAddress;
            [activityIndicatorView stopIndicator];
        }];
    }
    
}
- (IBAction)googleSelectedPlaceButtonAction:(UIButton *)sender {
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            [self addAlertViewWithTile:@"위치를 가져오지 못하였습니다. 다시한번 실행해 주세요!" actionTitle:@"done" handler:nil];
            return;
        }
        if (place != nil) {
            self.homTownLabel.text = place.name;
        } else {
            [self addAlertViewWithTile:@"선택된 장소가 없습니다." actionTitle:@"done" handler:nil];
        }
    }];
    
    
}

#pragma mark - toolbar button action
/* 'done button' in custom toolbar, resign responder and keyboard hide notification */
- (void)doneButtonAction:(UIButton *)sender {
    [self.shortStoryTextView resignFirstResponder];
}

#pragma mark - keyboard notification action
/* action of keyboard show notification */
- (void)keyboardWillShowNotification:(NSNotification *)noti {
    /* get keyboard bounds and setting toolbar offset */
    CGRect willShowKeyboardBounds = [[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.mainScrollView.frame = CGRectMake(0,64,self.mainScrollView.frame.size.width, willShowKeyboardBounds.size.height*2);
}

/*  action of keyboard hide notification */
- (void)keyboardWillHideNotification:(NSNotification *)noti {
    self.mainScrollView.frame = CGRectMake(0,64,self.mainScrollView.frame.size.width, self.view.frame.size.height);
}

#pragma mark - get profile image
/* image change button action */
- (IBAction)profileImageChangeButtonAction:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker  = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    
    UIAlertAction *chooseLibrary = [UIAlertAction actionWithTitle:@"Take a photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alertController addAction:takePhoto];
    [alertController addAction:chooseLibrary];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/* selected image and change profile image in UIImageView */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.profileImage.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    /* 위경도 값을 얻기 위한 메소드
     NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
     NSLog(@"info %@", info);
     NSLog(@"referenceURL %@", referenceURL);
    
     PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[referenceURL] options:nil] lastObject];
     PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
     options.networkAccessAllowed = YES; //download asset metadata from iCloud if needed
    
     [asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
            CIImage *fullImage = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
        
            NSLog(@"%@", fullImage.properties.description);
            NSLog(@"%@", [[fullImage.properties objectForKey:@"{GPS}"] objectForKey:@"Latitude"]);
            NSLog(@"%@", [[fullImage.properties objectForKey:@"{GPS}"] objectForKey:@"Longitude"]);
     }];
     */
}

#pragma mark - right bar button item
- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    
    /**
     * 자신의 홈타운을 설정하지 않은 경우, homTownLabel.text의 class를 확인하면 nil로 표시 된다(po [self.homTownLabel.text class] // nil).
     * 하지만 다른 UITextfield와 UITextView의 text는 __NSCFConstantString로 확인 된다.
     * 문제는 homTownLabel.text가 NSString 타입이 아닐 때 AFNetworking의 메소드에 들어갔을 때 오류가 발생하였다.
     * 추가로 loginManager의  uploadProfilePersonalInformationWithNickname 메소드에서, UITextfield와 UITextView의 text  <object returned empty description> 형태로 출력 되지만(po nickname), homTownLabel.text(po hometown)는 nil로 나타났다.
     * 따라서, self.homTownLabel.text의 class를 확인하여 NSString이 아닌 경우에 빈값을 넣어 해당 오류를 잡았다.
     */
    if (![self.homTownLabel.text isKindOfClass:[NSString class]]) {
        self.homTownLabel.text = @"";
    }
    
    [[RCLoginManager loginManager] uploadProfilePersonalInformationWithNickname:self.nickNameTextField.text hometown:self.homTownLabel.text selfIntroduction:self.shortStoryTextView.text complition:^(BOOL isSucceess, NSInteger code) {
        if (!isSucceess) {
            if (code == 400) {
                [self addAlertViewWithTile:@"동일한 닉네임이 있습니다. 다른 닉네임을 사용해 주세요." actionTitle:@"done" handler:nil];
            }
        } else {
            [[RCLoginManager loginManager] uploadProfileImageWithUIImage:self.profileImage.image complition:^(BOOL isSucceess, NSInteger code) {
                if (!isSucceess) {
                    [self addAlertViewWithTile:[@"프로필 사진 저장 오류" stringByAppendingString:[NSString stringWithFormat:@"%ld", code]] actionTitle:@"done" handler:nil];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }];
    
}

#pragma mark - left bar button item
- (IBAction)cancelBarButtonActin:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - texview delegate
/* textview should begin editing and keboad show notification */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.shortStoryTextView) {
        /* 다시 사용한 이유 : 글을 쓴 후 다시 입력하려 하면 남은 글자가 아니라 140이라는 초기 글자가 나타났기 때문에 */
        self.countCharcterLabelInKeyboard.text = [NSString stringWithFormat:@"%ld", 140 - textView.selectedRange.location];
    }
    return YES;
}

/* If tesxtview end editing and has text, placeholder hide */
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (![textView hasText]) {
        self.textViewplaceHolderLB.hidden = NO;
        self.doneButtonInKeyboard.enabled = YES;
        self.saveProfileButtonFromMemberStoryboard.enabled = YES;
    }
}

/* If tesxtview did change, placeholder hide and keyboard toolbar show */
- (void)textViewDidChange:(UITextView *)textView {
    if(![textView hasText]) {
        self.textViewplaceHolderLB.hidden = NO;
        self.doneBarBtnInNavi.enabled = YES;
    } else if (textView.selectedRange.location <= 140) {
        self.textViewplaceHolderLB.hidden = YES;
        self.countCharcterLabelInKeyboard.text = [NSString stringWithFormat:@"%ld", 140 - textView.selectedRange.location];
        self.countCharcterLabelInKeyboard.textColor = [UIColor colorWithRed:56/255.0f green:61/255.0f blue:73/255.0f alpha:1.0f];
        [self.doneButtonInKeyboard setTitleColor:[UIColor colorWithRed:56/255.0f green:61/255.0f blue:73/255.0f alpha:1.0f] forState:UIControlStateNormal];
        self.doneButtonInKeyboard.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:17.0f];
        self.doneButtonInKeyboard.enabled = YES;
        self.doneBarBtnInNavi.enabled = YES;
        self.saveProfileButtonFromMemberStoryboard.enabled = YES;
    } else {
        self.doneButtonInKeyboard.enabled = NO;
        self.countCharcterLabelInKeyboard.text = [NSString stringWithFormat:@"%ld", 140 - textView.selectedRange.location];
        self.countCharcterLabelInKeyboard.textColor = [UIColor redColor];
        self.doneButtonInKeyboard.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17.0f];
        [self.doneButtonInKeyboard setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.doneBarBtnInNavi.enabled = NO;
        self.saveProfileButtonFromMemberStoryboard.enabled = NO;
    }
}

/* limit text and resignFirstResponder */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    BOOL charNumLimitBool = range.location <= 140;
    if (charNumLimitBool) {
        self.countCharcterLabelInKeyboard.text = [NSString stringWithFormat:@"%ld", 140 - range.location];
        self.doneButtonInKeyboard.enabled = charNumLimitBool;
        self.doneBarBtnInNavi.enabled = charNumLimitBool;
        self.saveProfileButtonFromMemberStoryboard.enabled = charNumLimitBool;
    }
    
    /* enabled 과 userInteractionEnabled 차이는? */
    /*
     enabled은po charNumLimitBool UIControl의 서브클래스에서 사용된다 (UIbutton 같은 것)
     userInteractionEnabled은 UIView의 서브클래스에서 사용된다.
     따라서 UIButton에서는 enabled를 통하여 활성화 여부를 조절한다.
     */
    
    return YES;

}


#pragma mark - save button action
- (IBAction)saveProfileSetButtonAction:(UIButton *)sender {
    if (sender == self.saveProfileButtonFromMemberStoryboard) {
        /* #pragma mark - right bar button item 부분의 saveBarButtonAction 메소드 참조  */
        if (![self.homTownLabel.text isKindOfClass:[NSString class]]) {
            self.homTownLabel.text = @"";
        }
        
        /* hometown 에 아무것도 안들어갈 경우 문제가 생김*/
        [[RCLoginManager loginManager] uploadProfilePersonalInformationWithNickname:self.nickNameTextField.text hometown:self.homTownLabel.text selfIntroduction:self.shortStoryTextView.text complition:^(BOOL isSucceess, NSInteger code) {
            if (!isSucceess) {
                if (code == 400) {
                    [self addAlertViewWithTile:@"동일한 닉네임이 있습니다.. 닉네임을 변경해 주세요!" actionTitle:@"done" handler:nil];
                }
                
            } else {
                [[RCLoginManager loginManager] uploadProfileImageWithUIImage:self.profileImage.image complition:^(BOOL isSucceess, NSInteger code) {
                    if (!isSucceess) {
                        [self addAlertViewWithTile:[@"프로필 사진 저장 오류" stringByAppendingString:[NSString stringWithFormat:@"%ld", code]] actionTitle:@"done" handler:nil];
                    } else {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }
}

#pragma mark - alert method
- (void)addAlertViewWithTile:(nullable NSString *)viewTitle actionTitle:(nullable NSString *)actionTitle handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:viewTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertView addAction:done];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - etc
/* notification remove */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
