//
//  RCInDiaryLocationViewController.m
//  Record
//
//  Created by CLAY on 2017. 4. 9..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCInDiaryLocationViewController.h"

#import "RCInDiaryLocationView.h"

@import GoogleMaps;

@interface RCInDiaryLocationViewController ()
<RCInDiaryLocationDelegate>

@property (weak, nonatomic) IBOutlet UIView *inDiaryLocationView;
@property (weak, nonatomic) RCInDiaryLocationView *googleMapView;

@end

@implementation RCInDiaryLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RCInDiaryLocationView *googleMapView = [[[NSBundle mainBundle] loadNibNamed:@"RCInDiaryLocationView"
                                                           owner:self
                                                         options:nil] objectAtIndex:0];
    
    [googleMapView setDelegate:self];
    
    [googleMapView setFrame:self.inDiaryLocationView.bounds];
    self.googleMapView = googleMapView;
    
    [self.inDiaryLocationView addSubview:googleMapView];
}

- (IBAction)clickDoneButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)googleMapViewDidLoad:(GMSMapView *)mapView {
    
    if(self.inDiaryData != nil) {
        
//        [self.googleMapView googleMapCameraChangedAtIndex:self.indexPath whtiData:self.inDiaryData];
        
    } else {
        
        [self.googleMapView googleMapCameraChangedDefault];
    }
}

@end
