//
//  RCMyTravelDiaryBookViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 4. 18..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCMyTravelDiaryBookViewController.h"
#import "RCMyTravelBookFirstPageView.h"
#import "RCDiaryManager.h"
#import "MPFlipTransition.h"
#import <QuartzCore/QuartzCore.h>
#import "MPFlipEnumerations.h"
#import <CoreLocation/CoreLocation.h>
#import <DGActivityIndicatorView.h>
#import "RCIndicatorUtil.h"

@interface RCMyTravelDiaryBookViewController ()

@property (nonatomic) NSMutableArray *viewArray;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipeGesture;
@property NSInteger number;

@end

@implementation RCMyTravelDiaryBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* set navigation title */
    self.navigationItem.title = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryName;
    
    /* set alertcontroller  */

    RCIndicatorUtil *activityIndicatorView = [[RCIndicatorUtil alloc] initWithTargetView:self.view isMask:YES];
    [activityIndicatorView startIndicator];
    
    /* to get total page number */
    NSInteger totalPageNumber = 1;
    NSInteger countOfinDiaryForTotalPage = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
    for (NSInteger j = 0; j < countOfinDiaryForTotalPage ; j++) {
        NSInteger countOfinDiaryPhoto = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryPhotosArray.count;
        totalPageNumber += 1;
        if (countOfinDiaryPhoto != 0) {
            for (NSInteger k = 0; k < countOfinDiaryPhoto; k++) {
                if (!(k == countOfinDiaryPhoto - 1 && countOfinDiaryPhoto % 2 == 1)) {
                }
                k += 1;
                totalPageNumber += 1;
            }
        }
    }
    
    /* get relative travel book view */
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /********************** In viewDidLoad first page **********************/
        
        /* load nib file */
        RCMyTravelBookFirstPageView *firstPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookFirstPageView" owner:self options:nil] objectAtIndex:0];
        /* insert title */
//        firstPageView.titleLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryName;
        NSInteger pageNum = 1;
        firstPageView.pageNumberLB.text = [NSString stringWithFormat:@"%ld", pageNum];
        firstPageView.totalPageLB.text = [NSString stringWithFormat:@"%ld", totalPageNumber];;
        /* inserted between dates */
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setCalendar:[NSCalendar currentCalendar]];
//        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *startDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryStartDate];
//        NSString *endDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryEndDate];
//        firstPageView.fromFirstDayToLastDayLB.text = [startDate stringByAppendingString:[NSString stringWithFormat:@" ~ %@", endDate]];
        
        
        /* inserted total days */
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryStartDate toDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryEndDate options:NSCalendarWrapComponents];
//        firstPageView.totalDaysLB.text = [NSString stringWithFormat:@"%ld", [components day]+1];
        
        /* post number */
//        NSInteger inDiaryPostNumber = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
//        firstPageView.totalPostsLB.text = [NSString stringWithFormat:@"%ld", inDiaryPostNumber];
        
        /* photo number */
//        NSInteger inDiaryPhotoNumber = 0;
//        for (NSInteger i = 0; i < inDiaryPostNumber ; i++) {
//            inDiaryPhotoNumber += [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i].inDiaryPhotosArray.count;
//        }
//        firstPageView.totalPhotosLB.text = [NSString stringWithFormat:@"%ld", inDiaryPhotoNumber];
        
        /* GPS */
        firstPageView.recivedIndexPath = self.recivedIndexPath;
        firstPageView.frame = self.view.frame;
        
        
        NSInteger countOfinDiary = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
//        CGFloat totalDistanceMeter = 0;
//        /* distance */
//        for (NSInteger i = 0 ; i < countOfinDiary - 1 ; i++) {
//            CLLocationDegrees startLatitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i].inDiaryLocationLatitude.floatValue;
//            CLLocationDegrees startLongitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i].inDiaryLocationLongitude.floatValue;
//            CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
//            
//            CLLocationDegrees endtLatitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i+1].inDiaryLocationLatitude.floatValue;
//            CLLocationDegrees endLongitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[i+1].inDiaryLocationLongitude.floatValue;
//            CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:endtLatitude longitude:endLongitude];
//            
//            CLLocationDistance distance = [endLocation distanceFromLocation:startLocation];
//            totalDistanceMeter += distance;
//            
//        }
//        firstPageView.totalDistanceLB.text = [NSString stringWithFormat:@"%.2lf", totalDistanceMeter/1000];
        [viewArray addObject:firstPageView];
        
        
        /********************** In viewDidLoad other page **********************/
        
        for (NSInteger j = 0; j < countOfinDiary ; j++) {
            RCMyTravelBookSecondPageView *secondPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookSecondPageView" owner:self options:nil] objectAtIndex:0];
//            secondPageView.contentsOfPostingLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryContent;
//            secondPageView.latitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryLocationLatitude.stringValue;
//            secondPageView.longitude = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryLocationLongitude.stringValue;
            secondPageView.inDiaryArrayNumber = j;
            secondPageView.recivedIndexPath = self.recivedIndexPath;
//            secondPageView.currentDayOfThisPostLB.text = [NSString stringWithFormat:@"%ld", j + 1];
            
            [viewArray addObject:secondPageView];
            NSInteger countOfinDiaryPhoto = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryPhotosArray.count;
            pageNum += 1;
            secondPageView.pageNumberLB.text = [NSString stringWithFormat:@"%ld", pageNum];
            secondPageView.totalPageLB.text = [NSString stringWithFormat:@"%ld", totalPageNumber];
            if (countOfinDiaryPhoto != 0) {
                for (NSInteger k = 0; k < countOfinDiaryPhoto; k++) {
                    RCMyTravelBookRemainPhotoPageView *remainPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookRemainPhotoPageView" owner:self options:nil] objectAtIndex:0];
//                    remainPageView.firstPhotoImageView.image = [UIImage imageWithData:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryPhotosArray[k].inDiaryPhoto];
                    remainPageView.recivedIndexPath = self.recivedIndexPath;
                    remainPageView.inDiaryArrayNumber = j;
                    remainPageView.inDiaryPhotosArrayCount = k;
                    if (!(k == countOfinDiaryPhoto - 1 && countOfinDiaryPhoto % 2 == 1)) {
                        remainPageView.secondPhotoImageView.image = [UIImage imageWithData:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryPhotosArray[k + 1].inDiaryPhoto];
                    }
                    [viewArray addObject:remainPageView];
                    k += 1;
                    pageNum += 1;
                    remainPageView.pageNumberLB.text = [NSString stringWithFormat:@"%ld", pageNum];
                    remainPageView.totalPageLB.text = [NSString stringWithFormat:@"%ld", totalPageNumber];
                }
            }
            
        }
        self.number = 0;
        self.viewArray = viewArray;
        for (NSInteger i = self.viewArray.count -1; i >= 0; i--) {
            
            [self.view addSubview:self.viewArray[i]];
            
            if (i == 0) {
                [activityIndicatorView stopIndicator];
//                [self.viewArray removeObjectAtIndex:self.viewArray.count];
            }
        }
    });

}

- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)upSwipeGestureAction:(UISwipeGestureRecognizer *)sender {
    NSLog(@"upSwipeGestureAction");
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        if (self.number < self.viewArray.count - 1) {
            self.upSwipeGesture.enabled = NO;
            self.downSwipeGesture.enabled = NO;
            [MPFlipTransition transitionFromView:self.viewArray[self.number]
                                          toView:self.viewArray[self.number + 1]
                                        duration:[MPTransition defaultDuration]
                                           style:MPFlipStyleOrientationVertical
                                transitionAction:MPTransitionActionAddRemove
                                      completion:^(BOOL finished) {
                                          if (finished) {
                                              self.number += 1;
                                              self.upSwipeGesture.enabled = YES;
                                              self.downSwipeGesture.enabled = YES;
                                          }
                                      }];
        }
    }
    
}

- (IBAction)downSwipeGestureAction:(UISwipeGestureRecognizer *)sender {
    NSLog(@"downSwipeGestureAction");
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        if (self.number > 0) {
            self.upSwipeGesture.enabled = NO;
            self.downSwipeGesture.enabled = NO;
            [MPFlipTransition transitionFromView:self.viewArray[self.number]
                                          toView:self.viewArray[self.number - 1]
                                        duration:[MPTransition defaultDuration]
                                           style:MPFlipStyleFlipDirectionBit(MPFlipStyleOrientationVertical)
                                transitionAction:MPTransitionActionAddRemove
                                      completion:^(BOOL finished) {
                                          if (finished) {
                                              self.number -= 1;
                                              self.upSwipeGesture.enabled = YES;
                                              self.downSwipeGesture.enabled = YES;
                                          }
                                      }];
        }
    }
    
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
