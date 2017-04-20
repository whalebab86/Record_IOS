//
//  RCUtilyValidation.h
//  Record
//
//  Created by abyssinaong on 2017. 3. 31..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RCUtilyValidation : NSObject

+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidPW:(NSString *)userPW;
+ (UIImage*)setResizeImage:(UIImage *)imageToResize onImageView:(UIImageView *)imageView;

@end
