//
//  RCInDiaryDetailViewController.m
//  Record
//
//  Created by CLAY on 2017. 4. 7..
//  Copyright © 2017년 whalebab. All rights reserved.
//

/* Record controller import */
#import "RCInDiaryDetailViewController.h"

/* Record source import */
#import "DateSource.h"

/* library import */
@import GooglePlacePicker;
#import <SDWebImage/UIImageView+WebCache.h>
#import <QBImagePickerController/QBImagePickerController.h>

typedef NS_ENUM(NSInteger, RCInDiaryStatusMode) {
    RCInDiaryStatusModeInsert,
    RCInDiaryStatusModeUpdate
};

@interface RCInDiaryDetailViewController ()
<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate,
QBImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *inDiaryDatePicker;
@property (weak, nonatomic) IBOutlet UIView *inDiaryPhotoView;

@property (weak, nonatomic) IBOutlet UIScrollView *inDiaryScrollView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryScrollContentView;
@property (weak, nonatomic) IBOutlet UIView *inDiaryDeleteView;

@property (weak, nonatomic) IBOutlet UILabel *inDiaryLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *inDiaryDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *inDiaryContentTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *inDiaryCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryScrollViewBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryPhotoButtonBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDateViewHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDeleteViewBottomConstraints;

@property (nonatomic) RCInDiaryStatusMode inDiaryStatusMode;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) GMSPlacePicker *placePicker;
@property (nonatomic) GMSPlacesClient *placesClient;

@property (weak, nonatomic) IBOutlet UIButton *inDiaryLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *inDiaryCurrentLocationButton;

@property (nonatomic) NSMutableArray *inDiaryImageArray;

@end

@implementation RCInDiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* Google Map place */
    self.placesClient = [GMSPlacesClient sharedClient];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    /* Custom image picker array  */
    self.inDiaryImageArray = [[NSMutableArray alloc] init];
    
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
        
        /* current location */
        [self findCurrentLocation];
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
//        [self.inDiaryCollectionView setHidden:YES];
    }
    
//    return itemCount;
    
    return [self.inDiaryImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCInDiaryListViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//    NSString *imageUrl = [self.inDiaryData.inDiaryCoverImgUrl objectAtIndex:indexPath.row];
    
//    [cell.inDiaryCollectionImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
//                                       placeholderImage:[UIImage imageNamed:@"RCSignInUpTopImage"]];
    
    
    [cell.inDiaryCollectionImageView setImage:[self.inDiaryImageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITextFieldView Delegate
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

#pragma mark - QBImagePickerController Delegate
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    PHImageManager *manager = [PHImageManager defaultManager];

//    CGFloat scale = UIScreen.mainScreen.scale;
    
    [self.inDiaryImageArray removeAllObjects];
    
    for (PHAsset *asset in assets) {
        // Do something with the asset
        NSLog(@"%@", asset.localIdentifier);
        
        CGSize targetSize = CGSizeMake(1000, 1000);
        
        PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        
        [manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil
                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            
                            [self.inDiaryImageArray addObject:result];
//
        }];
    }
    
    [self.inDiaryCollectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Custom button click Method
- (IBAction)clickLocationButton:(UIButton *)sender {
    
    [self.locationManager requestWhenInUseAuthorization];
    
    if(sender == self.inDiaryCurrentLocationButton) {
        
        [self findCurrentLocation];
    } else if(sender == self.inDiaryLocationButton) {
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(37.788204, -122.411937);
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                      center.longitude + 0.001);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                      center.longitude - 0.001);
        
        GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                             coordinate:southWest];
        GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
        _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
        
        [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
            if (error != nil) {
                NSLog(@"Pick Place error %@", [error localizedDescription]);
                return;
            }
            
            if (place != nil) {
                
                self.inDiaryLocationLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
                
            } else {
                self.inDiaryLocationLabel.text = @"No place selected";
            }
        }];
    }
}

- (IBAction)clickDateButton:(id)sender {
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

- (IBAction)clickPhotosButton:(UIButton *)sender {
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 3;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
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
        //        [self.inDiaryContentTextView becomeFirstResponder];
    } else {
        //        [self.inDiaryContentTextView resignFirstResponder];
    }
    
    NSLog(@"Tap");
}

#pragma mark - Custom Method
- (void)findCurrentLocation {
    
    self.inDiaryLocationLabel.text = @"current location loading....";
    
    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                
                NSString *locationInfo = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
                
                self.inDiaryLocationLabel.text = locationInfo;
            }
        }
    }];
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



