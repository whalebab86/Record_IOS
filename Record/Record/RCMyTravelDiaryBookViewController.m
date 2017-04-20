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

@interface RCMyTravelDiaryBookViewController ()

@property (weak, nonatomic) UIImageView *snapshotImageView;

@end

@implementation RCMyTravelDiaryBookViewController
- (void)loadView {
    [super loadView];
    //    [[RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item]];
    /* load nib file */
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
    
    //    [self.view addSubview:firstPageView];
    
    
    RCMyTravelBookSecondPageView *secondPageView = [[[NSBundle mainBundle] loadNibNamed:@"RCMyTravelBookSecondPageView" owner:self options:nil] objectAtIndex:0];
    secondPageView.contentsOfPostingLB.text = [RCDiaryManager diaryManager].diaryResults[self.recivedIndexPath.item].inDiaryArray[0].inDiaryContent;
    secondPageView.latitude = @"37.5653203";
    secondPageView.longitude = @"126.9745883";
    
    
//    [self.view addSubview:secondPageView];
    //    UIView *subView = self.viewWithManySubViews;
    UIGraphicsBeginImageContextWithOptions(secondPageView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [secondPageView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshotImage];
    snapshotImageView.frame = self.view.frame;
    self.snapshotImageView = snapshotImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.view addSubview:self.snapshotImageView];
    
}



- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)upSwipeGestureAction:(UISwipeGestureRecognizer *)sender {
    NSLog(@"upSwipeGestureAction");
}

- (IBAction)downSwipeGestureAction:(UISwipeGestureRecognizer *)sender {
    NSLog(@"downSwipeGestureAction");
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
