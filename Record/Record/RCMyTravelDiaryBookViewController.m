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
        NSInteger pageNum = 1;
        firstPageView.pageNumberLB.text = [NSString stringWithFormat:@"%ld", pageNum];
        firstPageView.totalPageLB.text = [NSString stringWithFormat:@"%ld", totalPageNumber];;
        
        /* GPS */
        firstPageView.recivedIndexPath = self.recivedIndexPath;
        firstPageView.frame = self.view.frame;
        
        
        NSInteger countOfinDiary = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count;
        [viewArray addObject:firstPageView];
        
        
        /********************** In viewDidLoad other page **********************/
        
        for (NSInteger j = 0; j < countOfinDiary ; j++) {
            RCMyTravelBookSecondPageView *secondPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookSecondPageView" owner:self options:nil] objectAtIndex:0];
            secondPageView.inDiaryArrayNumber = j;
            secondPageView.recivedIndexPath = self.recivedIndexPath;
            
            [viewArray addObject:secondPageView];
            NSInteger countOfinDiaryPhoto = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[j].inDiaryPhotosArray.count;
            pageNum += 1;
            secondPageView.pageNumberLB.text = [NSString stringWithFormat:@"%ld", pageNum];
            secondPageView.totalPageLB.text = [NSString stringWithFormat:@"%ld", totalPageNumber];
            if (countOfinDiaryPhoto != 0) {
                for (NSInteger k = 0; k < countOfinDiaryPhoto; k++) {
                    RCMyTravelBookRemainPhotoPageView *remainPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookRemainPhotoPageView" owner:self options:nil] objectAtIndex:0];
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
