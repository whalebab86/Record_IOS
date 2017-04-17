//
//  RCSplashViewController.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 27..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Google/SignIn.h>
#import <FLAnimatedImageView+WebCache.h>
#import "RCSplashViewController.h"
#import "RCLoginManager.h"
#import "RCSplashTutorialCollectionViewCell.h"

@interface RCSplashViewController ()
<GIDSignInDelegate, GIDSignInUIDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *tutorialCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *tutorialCollectioViewFlowLayout;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialCollectionViewPageControl;
@property NSArray *mainCollectionviewDataArray;
@end

@implementation RCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [[RCLoginManager loginManager] checkValidTokenWithComplition:^(BOOL isSucceess, NSInteger code) {
        if (isSucceess) {
            NSLog(@"checkValidTokenWithComplition success!!!");
        } else {
            NSLog(@"checkValidTokenWithComplition fail!!!");
        }
    }];
    
    
    /* Signin button change layer and layer color */
    self.signInBtn.layer.borderWidth = 1.0f;
    self.signInBtn.layer.cornerRadius = 3.0f;
    self.signInBtn.layer.borderColor = [UIColor colorWithRed:106/255.0f green:108/255.0f blue:114/255.0f alpha:1.0f].CGColor;
    
    /* facebook button cornerRadius */
    self.facebookBtn.layer.cornerRadius = 3.0f;
    
    /* google button cornerRadius */
    self.googleBtn.layer.cornerRadius = 3.0f;
    
    /* google sign in delegate */
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate= self;
    
    /* collection view delegate and datasource */
    self.tutorialCollectionView.delegate = self;
    self.tutorialCollectionView.dataSource = self;
    self.tutorialCollectionView.pagingEnabled = YES;
    [self setupDataForCollectionView];
    NSLog(@"%@", self.mainCollectionviewDataArray);
}

- (void)viewDidLayoutSubviews {
    
    self.tutorialCollectioViewFlowLayout.itemSize = self.tutorialCollectionView.frame.size;
}


-(void)setupDataForCollectionView {
    
    // Create the original set of data
    NSArray *originalArray = @[@"RC_splash_main_img_two", @"RC_splash_main_img_three", @"gifFile"];
    
    // Grab references to the first and last items
    // They're typed as id so you don't need to worry about what kind
    // of objects the originalArray is holding
    id firstItem = [originalArray firstObject];
    id lastItem = [originalArray lastObject];
    
    NSMutableArray *workingArray = [originalArray mutableCopy];
    
    // Add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // Add the copy of the first item to the end
    [workingArray addObject:firstItem];
    
    // Update the collection view's data source property
    self.mainCollectionviewDataArray = [NSArray arrayWithArray:workingArray];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.mainCollectionviewDataArray.count;
}

-(void)scrollViewDidEndDecelerating:(UICollectionView *)scrollview {
//scrollview.frame.size.width
    CGFloat contentOffsetWhenFullyScrolledRight = self.tutorialCollectioViewFlowLayout.itemSize.width * ([self.mainCollectionviewDataArray count] -1);

    if (scrollview.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.tutorialCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    } else if (scrollview.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.mainCollectionviewDataArray count] -2) inSection:0];
        
        [self.tutorialCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    NSLog(@"indexPath.item %ld", indexPath.item);
//    if (indexPath.item <= 2) {
//        self.tutorialCollectionViewPageControl.currentPage = indexPath.item;
//    } else if (indexPath.item == 3) {
//        
//        self.tutorialCollectionViewPageControl.currentPage = indexPath.item -3;
//    } else if (indexPath.item == 4) {
//        self.tutorialCollectionViewPageControl.currentPage = indexPath.item -4;
//    }
    
    RCSplashTutorialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCSplashTutorialCollectionViewCell" forIndexPath:indexPath];

//    if (indexPath.item == 0 || indexPath.item == 3) {
//        //@"splash_main_img.gif"
//        NSData *gifImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"splash_main_img" ofType:@"gif"]];
//        cell.cellItemImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifImageData];
//        return cell;
//    } else {
//        cell.cellItemImageView.image = [UIImage imageNamed:self.mainCollectionviewDataArray[indexPath.item]];
//        return cell;
//    }
    
    NSData *gifImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"splash_main_img" ofType:@"gif"]];
    switch (indexPath.item) {
        case 0:
            cell.cellItemImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifImageData];
            self.tutorialCollectionViewPageControl.currentPage = 0;
            return cell;
            break;
        case 1:
            cell.cellItemImageView.image = [UIImage imageNamed:self.mainCollectionviewDataArray[indexPath.item]];
            self.tutorialCollectionViewPageControl.currentPage = 1;
            return cell;
            break;
        case 2:
            cell.cellItemImageView.image = [UIImage imageNamed:self.mainCollectionviewDataArray[indexPath.item]];
            self.tutorialCollectionViewPageControl.currentPage = 2;
            return cell;
            break;
        case 3:
            cell.cellItemImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifImageData];
            self.tutorialCollectionViewPageControl.currentPage = 3;
            return cell;
            break;
        case 4:
            cell.cellItemImageView.image = [UIImage imageNamed:self.mainCollectionviewDataArray[indexPath.item]];
            self.tutorialCollectionViewPageControl.currentPage = 0;
            return cell;
            break;
        default:
            cell.cellItemImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifImageData];
            self.tutorialCollectionViewPageControl.currentPage = 1;
            return cell;
            break;
    }
    
}



#pragma mark - Create account with Facebook
/* create account with facebook */
- (IBAction)facebookLoginButtonAction:(UIButton *)sender {
    
    if(sender == self.facebookBtn) {
        NSLog(@"facebookLoginButtonAction");
        [[RCLoginManager loginManager] confirmFacebookLoginfromViewController:self complition:^(BOOL isSucceess, NSInteger code) {
            if (isSucceess) {
                [self performSegueWithIdentifier:@"ProfileSettingSegueFromSplash" sender:nil];
                NSLog(@"confirmFacebookLoginfromViewController");
            } else {
                NSString *alertTitle = [@"facebook login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
                [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
            }
        }];
    }
}

#pragma mark - Create account with Google
/* create account with google */
- (IBAction)googleLoginButtonAction:(UIButton *)sender {
    if (sender == self.googleBtn) {
        [[GIDSignIn sharedInstance] signIn];
    }
}


/**
 *로그인 이후 뷰컨트롤러 연결은 다음 setting page 이후 만들것임.
 */
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    NSLog(@"signInWillDispatch signIn %@", signIn);
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    [[RCLoginManager loginManager] recivedGoogleUserInfo:user complition:^(BOOL isSucceess, NSInteger code) {
        if (isSucceess) {
            NSLog(@"googleSuccess");
            [self performSegueWithIdentifier:@"SettingSegueFromSplash" sender:nil];
        } else {
            NSString *alertTitle = [@"google login error (code " stringByAppendingString:[NSString stringWithFormat:@"%ld )", code]];
            [self addAlertViewWithTile:alertTitle actionTitle:@"Done" handler:nil];
        }
    }];
    
}

#pragma mark - alert method
- (void)addAlertViewWithTile:(nullable NSString *)viewTitle actionTitle:(nullable NSString *)actionTitle handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:viewTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:handler];
    [alertView addAction:done];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - etc

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
