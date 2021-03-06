//
//  RCUtilyValidation.m
//  Record
//
//  Created by abyssinaong on 2017. 3. 31..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import "RCUtilyValidation.h"

@implementation RCUtilyValidation


+ (BOOL)isValidEmail:(NSString *)email {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:email];
    
    return result;
}

+ (BOOL)isValidPW:(NSString *)userPW {
    if ( userPW.length > 20 || userPW.length < 7 )
        return NO;
    
    NSString *filter = @"^(?=.*[0-9])(?=.*[A-Za-z])([A-Za-z0-9]){8,20}$";
    NSPredicate *idRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    BOOL result = [idRegex evaluateWithObject:userPW];
    
    return result;
}

+ (UIImage*)setResizeImage:(UIImage *)imageToResize onImageView:(UIImageView *)imageView {
    CGFloat width = imageToResize.size.width;
    CGFloat height = imageToResize.size.height;
    float scaleFactor;
    if(width > height)
    {
        scaleFactor = imageView.frame.size.height / height;
    }
    else
    {
        scaleFactor = imageView.frame.size.width / width;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width * scaleFactor, height * scaleFactor), NO, 0.0);
    [imageToResize drawInRect:CGRectMake(0, 0, width * scaleFactor, height * scaleFactor)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}



@end
