//
//  RCMemberValidation.h
//  Record
//
//  Created by abyssinaong on 2017. 3. 31..
//  Copyright © 2017년 whalebab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCMemberValidation : NSObject

+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidPW:(NSString *)userPW;


@end
