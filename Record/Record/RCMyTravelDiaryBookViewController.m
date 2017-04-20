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

@interface RCMyTravelDiaryBookViewController ()

@property (weak, nonatomic) UIImageView *snapshotImageView;
@property NSMutableArray *viewArray;
@property NSInteger number;
@end

@implementation RCMyTravelDiaryBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item]];
    /* load nib file */
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i <3; i ++ ) {
        if (i == 0) {
            RCMyTravelBookFirstPageView *firstPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookFirstPageView" owner:self options:nil] objectAtIndex:0];
            /* insert title */
            firstPageView.titleLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryName;
            
            /* inserted between dates */
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setCalendar:[NSCalendar currentCalendar]];
            [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
            [dateFormatter setDateFormat:@"yy-MMM-dd"];
            NSString *startDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryStartDate];
            NSString *endDate = [dateFormatter stringFromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryEndDate];
            firstPageView.fromFirstDayToLastDayLB.text = [startDate stringByAppendingString:endDate];
            
            /* inserted total days */
            NSDateComponents *components;
            components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryStartDate toDate:[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].diaryEndDate options:0];
            firstPageView.totalDaysLB.text = [NSString stringWithFormat:@"%ld", [components day]];
            
            /* post number */
            firstPageView.totalPostsLB.text = [NSString stringWithFormat:@"%ld", [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray.count];
            
            firstPageView.latitude = @"37.5653203";
            firstPageView.longitude = @"126.9745883";
            firstPageView.frame = self.view.frame;
            [viewArray addObject:firstPageView];
        } else {
            RCMyTravelBookSecondPageView *secondPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookSecondPageView" owner:self options:nil] objectAtIndex:0];
            secondPageView.contentsOfPostingLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[0].inDiaryContent;
            secondPageView.latitude = @"37.5653203";
            secondPageView.longitude = @"126.9745883";
            [viewArray addObject:secondPageView];
        }
    }
    self.viewArray = viewArray;

    self.number = 0;
    for (NSInteger i = self.viewArray.count; i >= 0; i --) {
        [self.view addSubview:self.viewArray[i]];
    }
    //    UIView *subView = self.viewWithManySubViews;
//    UIGraphicsBeginImageContextWithOptions(secondPageView.bounds.size, YES, 0.0f);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [secondPageView.layer renderInContext:context];
//    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshotImage];
//    self.snapshotImageView = snapshotImageView;
//    self.snapshotImageView.frame = self.view.frame;
//    
//
//    [self.view addSubview:self.snapshotImageView];
    
}


//- (void)


- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)upSwipeGestureAction:(UISwipeGestureRecognizer *)sender {
    NSLog(@"upSwipeGestureAction");
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        if (self.number >= -1) {
            [MPFlipTransition transitionFromView:self.viewArray[self.number]
                                          toView:self.viewArray[self.number + 1]
                                        duration:[MPTransition defaultDuration]
                                           style:MPFlipStyleOrientationVertical
                                transitionAction:MPTransitionActionAddRemove
                                      completion:nil];
            self.number += 1;
        }
    }
    
}

- (IBAction)downSwipeGestureAction:(UISwipeGestureRecognizer *)sender {
    NSLog(@"downSwipeGestureAction");
}


- (UIView * )addSubviewWithIndex:(NSInteger)index {
    [self.view addSubview:self.viewArray[index]];
    return self.viewArray[index];
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
