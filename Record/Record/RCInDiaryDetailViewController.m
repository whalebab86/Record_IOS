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
#import "RCDiaryManager.h"
#import "RCDiaryRealm.h"

/* library import */
@import GooglePlacePicker;
#import <SDWebImage/UIImageView+WebCache.h>
#import <QBImagePickerController/QBImagePickerController.h>
#import "DGActivityIndicatorView.h"

#import "RCIndicatorUtil.h"

typedef NS_ENUM(NSInteger, RCInDiaryStatusMode) {
    RCInDiaryStatusModeInsert,
    RCInDiaryStatusModeUpdate
};

@interface RCInDiaryDetailViewController ()
<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
CLLocationManagerDelegate, QBImagePickerControllerDelegate, RCInDiaryListViewCollectionViewCellDelegate>

/* view */
@property (weak, nonatomic) IBOutlet UIDatePicker     *inDiaryDatePicker;
@property (weak, nonatomic) IBOutlet UIView           *inDiaryPhotoView;

@property (weak, nonatomic) IBOutlet UIScrollView     *inDiaryScrollView;
@property (weak, nonatomic) IBOutlet UIView           *inDiaryScrollContentView;
@property (weak, nonatomic) IBOutlet UIView           *inDiaryDeleteView;

@property (weak, nonatomic) IBOutlet UILabel          *inDiaryLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel          *inDiaryDateLabel;
@property (weak, nonatomic) IBOutlet UITextView       *inDiaryContentTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *inDiaryCollectionView;

@property (weak, nonatomic) IBOutlet UIButton         *inDiaryLocationButton;
@property (weak, nonatomic) IBOutlet UIButton         *inDiaryCurrentLocationButton;

@property (nonatomic) RCIndicatorUtil                 *activityIndicatorView;

/* Constraint */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryScrollViewBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryPhotoButtonBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDateViewHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inDiaryDeleteViewBottomConstraints;


/* location */
@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) GMSPlacePicker    *placePicker;
@property (nonatomic) GMSPlacesClient   *placesClient;
@property (nonatomic) GMSPlace          *locationPlace;


/* data */
@property (nonatomic) RCInDiaryStatusMode inDiaryStatusMode;

@property (nonatomic) NSMutableArray *inDiaryImageArray;
@property (nonatomic) RCDiaryManager *manager;

@end

@implementation RCInDiaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Manager or Source  */
    self.manager        = [RCDiaryManager diaryManager];
    
    self.diaryRealm     = [self.manager.diaryResults objectAtIndex:self.diaryIndexPath.row];
    self.inDiaryResults = [self.diaryRealm.inDiaryArray sortedResultsUsingKeyPath:@"inDiaryReportingDate" ascending:NO];
    
    /* indicator */
    self.activityIndicatorView = [[RCIndicatorUtil alloc] initWithTargetView:self.view isMask:YES];
    //self.activityIndicatorView = indicator;
    
    /* Google Map place */
    self.placesClient = [GMSPlacesClient sharedClient];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    
    /* Custom image picker array  */
    self.inDiaryImageArray = [[NSMutableArray alloc] init];
    
    
    /* custom date picker */
    [self.inDiaryDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [self.inDiaryDatePicker setMinimumDate:self.diaryRealm.diaryStartDate];
    [self.inDiaryDatePicker setMaximumDate:self.diaryRealm.diaryEndDate];
    
    
    /* custom photo view */
    [self.inDiaryPhotoView.layer setCornerRadius:3];
    [self.inDiaryPhotoView setClipsToBounds:YES];
    
    
    /* custom delete view */
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
    
    /* inDiary information setting */
    if(self.indexPath == nil) {
        /* page status insert */
        self.inDiaryStatusMode = RCInDiaryStatusModeInsert;
        
        self.inDiaryRealm = [[RCInDiaryRealm alloc] init];
        
        self.inDiaryDatePicker.date = [NSDate date];
        
        self.inDiaryLocationLabel.text = @"current location loading....";
        self.inDiaryDateLabel.text     = [DateSource convertWithDate:self.inDiaryDatePicker.date format:@"yyyy-MM-dd E HH:mm"];
        
        [self.inDiaryDeleteView setHidden:YES];
        
        /* current location */
        [self findCurrentLocation];
    } else {
       
        /* page status update */
        self.inDiaryStatusMode = RCInDiaryStatusModeUpdate;
        
        self.inDiaryRealm = [self.inDiaryResults objectAtIndex:self.indexPath.row];
        
        self.inDiaryLocationLabel.text   = [[self.inDiaryRealm.inDiaryLocationCountry stringByAppendingString:@" "]
                                            stringByAppendingString:self.inDiaryRealm.inDiaryLocationName];
        
        self.inDiaryDatePicker.date      = self.inDiaryRealm.inDiaryReportingDate;
        self.inDiaryDateLabel.text       = [DateSource convertWithDate:self.inDiaryRealm.inDiaryReportingDate format:@"yyyy-MM-dd E HH:mm"];
        
        self.inDiaryContentTextView.text = self.inDiaryRealm.inDiaryContent;
        
        for (RCInDiaryPhotoRealm *data in self.inDiaryRealm.inDiaryPhotosArray) {
            [self.inDiaryImageArray addObject:data.inDiaryPhoto];
        }
    }
    
    [self.inDiaryCollectionView reloadData];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.inDiaryImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCInDiaryListViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSData *imageData = [self.inDiaryImageArray objectAtIndex:indexPath.row];
    
    [cell.inDiaryDeleteView.layer setCornerRadius:cell.inDiaryDeleteView.frame.size.height / 2];
    [cell.inDiaryDeleteView setClipsToBounds:YES];
    
    [cell.inDiaryCollectionImageView setImage:[UIImage imageWithData:imageData]];
    
    cell.indexPath = indexPath;
    
    [cell setDelegate:self];
    
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

//    [self.inDiaryImageArray removeAllObjects];
    
    [self.activityIndicatorView startIndicator];
    
    for (PHAsset *asset in assets) {
        // Do something with the asset
        NSLog(@"%@", asset.localIdentifier);
        
        CGSize targetSize = CGSizeMake(1200, 1200);
        
        PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        
        [manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions
                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            
                            [self.inDiaryImageArray addObject:UIImagePNGRepresentation(result)];
        }];
    }
    
    [self.activityIndicatorView stopIndicator];
    [self.inDiaryCollectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Custom button click Method
- (IBAction)clickLocationButton:(UIButton *)sender {
    
    [self.locationManager requestWhenInUseAuthorization];
    
    if(sender == self.inDiaryCurrentLocationButton) {
        
        /* current location */
        [self findCurrentLocation];
    } else if(sender == self.inDiaryLocationButton) {
        
        /* search location */
        [self findSearchLocation];
    }
}

- (IBAction)clickPhotosButton:(UIButton *)sender {
    
    if([self.inDiaryImageArray count] < 5) {
        
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.delegate = self;
        
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 5 - [self.inDiaryImageArray count];
        imagePickerController.showsNumberOfSelectedAssets = YES;
        
        [self presentViewController:imagePickerController animated:YES completion:NULL];
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

- (IBAction)clickCancelBarButton:(id)sender {
    
    [self.view endEditing:YES];
    
    [self.manager.realm transactionWithBlock:^{
        [self.manager.realm cancelWriteTransaction];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickDoneBarButton:(id)sender {
    
    [self.view endEditing:YES];
    
    /* in diary data setting */
    if(![self settingDiaryDataInfo]) {
        NSLog(@"fail");
        return;
    };
    
    if(self.inDiaryStatusMode == RCInDiaryStatusModeInsert) {
        
        /* page insert mode */
        [self.manager.realm transactionWithBlock:^{
            
            if(self.locationPlace != nil) {
                self.inDiaryRealm.inDiaryLocationLatitude = [NSNumber numberWithDouble:self.locationPlace.coordinate.latitude];
                self.inDiaryRealm.inDiaryLocationLongitude = [NSNumber numberWithDouble:self.locationPlace.coordinate.longitude];
                
                NSArray *placeArray = [self.locationPlace.formattedAddress componentsSeparatedByString:@" "];
                self.inDiaryRealm.inDiaryLocationCountry = [placeArray objectAtIndex:0];
                
                if([placeArray count] > 1) {
                    
                    NSRange range = NSMakeRange(1, [placeArray count]-1);
                    self.inDiaryRealm.inDiaryLocationName    = [[placeArray subarrayWithRange:range] componentsJoinedByString:@" "];
                }
            }
            
            self.inDiaryRealm.inDiaryPk     = [DateSource convertWithDate:[NSDate date] format:@"yyyyMMddHHmmssSSSS"];
            self.inDiaryRealm.diaryPk       = self.diaryRealm.diaryPk;
            self.inDiaryRealm.inDiaryContent = self.inDiaryContentTextView.text;
            self.inDiaryRealm.inDiaryReportingDate = self.inDiaryDatePicker.date;
            self.inDiaryRealm.inDiaryCreateDate = [NSDate date];
            
            [self.diaryRealm.inDiaryArray addObject:self.inDiaryRealm];
            
            [self.inDiaryRealm.inDiaryPhotosArray removeAllObjects];
            
            for (NSData *data in self.inDiaryImageArray) {
                
                RCInDiaryPhotoRealm *photo = [[RCInDiaryPhotoRealm alloc] init];
                photo.inDiaryPhoto = data;
                
                [self.inDiaryRealm.inDiaryPhotosArray addObject:photo];
            }
            
//            [self.inDiaryRealm.inDiaryPhotosArray addObjects:self.inDiaryImageArray];

//            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"unwindDiaryList" sender:nil];
        }];
        
    } else if(self.inDiaryStatusMode == RCInDiaryStatusModeUpdate) {
        /* page update mode */
        
        [self.manager.realm transactionWithBlock:^{
            
            if(self.locationPlace != nil) {
                self.inDiaryRealm.inDiaryLocationLatitude = [NSNumber numberWithDouble:self.locationPlace.coordinate.latitude];
                self.inDiaryRealm.inDiaryLocationLongitude = [NSNumber numberWithDouble:self.locationPlace.coordinate.longitude];
                
                NSArray *placeArray = [self.locationPlace.formattedAddress componentsSeparatedByString:@" "];
                self.inDiaryRealm.inDiaryLocationCountry = [placeArray objectAtIndex:0];
                
                if([placeArray count] > 1) {
                    
                    NSRange range = NSMakeRange(1, [placeArray count]-1);
                    self.inDiaryRealm.inDiaryLocationName    = [[placeArray subarrayWithRange:range] componentsJoinedByString:@" "];
                }
            }
            
            [self.inDiaryRealm.inDiaryPhotosArray removeAllObjects];
            for (NSData *data in self.inDiaryImageArray) {
                
                RCInDiaryPhotoRealm *photo = [[RCInDiaryPhotoRealm alloc] init];
                photo.inDiaryPhoto = data;
                
                [self.inDiaryRealm.inDiaryPhotosArray addObject:photo];
            }
//            [self.inDiaryRealm.inDiaryPhotosArray addObjects:self.inDiaryImageArray];
            
            self.inDiaryRealm.inDiaryContent = self.inDiaryContentTextView.text;
            self.inDiaryRealm.inDiaryReportingDate = self.inDiaryDatePicker.date;
            
//            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"unwindDiaryList" sender:nil];
        }];
        
    }
}

- (IBAction)clickDeleteButton:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete in diary"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self.manager.realm transactionWithBlock:^{
                                                             
                                                             [self.manager.realm deleteObject:self.inDiaryRealm];
                                                             
//                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                             [self performSegueWithIdentifier:@"unwindDiaryList" sender:nil];
                                                         }];
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - RCInDiaryDetailCollectionView Method
- (void)clickDeleteButton:(UIButton *)button indexPath:(NSIndexPath *)indexPath {

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete in diary photo"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [self.inDiaryImageArray removeObjectAtIndex:indexPath.row];
                                                         [self.inDiaryCollectionView reloadData];
                                                         
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Custom value change Method
- (IBAction)changeInDiaryDatePicker:(UIDatePicker *)sender forEvent:(UIEvent *)event {
    
    self.inDiaryDateLabel.text = [DateSource convertWithDate:sender.date format:@"yyyy-MM-dd E HH:mm"];
}

#pragma mark - Custom tap Method
- (IBAction)tapInDiaryScrollView:(UIGestureRecognizer *)sender {
    
    if(!self.inDiaryContentTextView.isFirstResponder) {
        //        [self.inDiaryContentTextView becomeFirstResponder];
    } else {
        //        [self.inDiaryContentTextView resignFirstResponder];
    }
    
    NSLog(@"Tap");
}

- (IBAction)tapScrollView:(UITapGestureRecognizer *)sender {
    
    if(self.inDiaryContentTextView.isFirstResponder) {
        
        //        [self.inDiaryContentTextView resignFirstResponder];
    }
}

#pragma mark - Custom Method

- (BOOL)settingDiaryDataInfo {
    
    NSString *msg = @"";
    BOOL result = NO;
    
    /* 공백 제거 */
    NSString *diaryName = [self.inDiaryContentTextView.text
                           stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if([self.inDiaryLocationLabel.text isEqualToString:@""] || self.inDiaryLocationLabel.text == nil) {
        
        msg = @"Location is empty";
    } else if([diaryName isEqualToString:@""]) {
        
        msg = @"In diary content is empty";
    } else {
        
        result = YES;
    }
    
    if(!result) {
        
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


/* current location */
- (void)findCurrentLocation {
    
    self.inDiaryLocationLabel.text = @"current location loading....";
    
    [self.activityIndicatorView startIndicator];
    
    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            self.locationPlace = nil;
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                
                self.locationPlace = place;
                
                NSString *locationInfo = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
                
                self.inDiaryLocationLabel.text = locationInfo;
                
                [self.activityIndicatorView stopIndicator];
            }
        }
    }];
}

/* search location */
- (void)findSearchLocation {
    
    CGFloat latitude  = self.locationPlace.coordinate.latitude;
    CGFloat longitude = self.locationPlace.coordinate.longitude;
    
    if(self.locationPlace == nil) {
        latitude  = [self.inDiaryRealm.inDiaryLocationLatitude doubleValue];
        longitude = [self.inDiaryRealm.inDiaryLocationLongitude doubleValue];
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:center
                                                                         coordinate:center];
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    
    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            
            self.locationPlace = nil;
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            
            self.locationPlace = place;
            
            NSString *locationInfo = [[place.formattedAddress componentsSeparatedByString:@", "]
                                      componentsJoinedByString:@"\n"];
            
            self.inDiaryLocationLabel.text = locationInfo;
            
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
        [self.inDiaryCollectionView setAlpha:0];
        
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]  && bottomConstant != 0) {
        
        self.inDiaryScrollViewBottomConstraints.constant  = 0;
        self.inDiaryPhotoButtonBottomConstraints.constant = 10;
        self.inDiaryDeleteViewBottomConstraints.constant  = 10;
        [self.inDiaryCollectionView setAlpha:1];
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

@end


@implementation RCInDiaryListViewCollectionViewCell

- (IBAction)clickDeleteButton:(UIButton *)sender {
    [self.delegate clickDeleteButton:sender indexPath:self.indexPath];
}

@end



