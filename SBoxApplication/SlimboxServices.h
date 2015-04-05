//
//  SocialMediaService.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "RACSignal.h"
#import "Singleton.h"
#import <UIKit/UIKit.h>
/**
 Services is responsible for all REST Methods. 
 */
@interface SlimboxServices : NSObject
SingletonInit
- (RACSignal*)facebookLoginUser;
- (RACSignal*)facebookGetUserData;
+ (void)test;
+ (RACSignal*)queryReceiptWithID:(NSString*)ID;
+ (RACSignal*)loadImageNamed:(NSString*)imageURL forImageView:(UIImageView*)imageView placeholderImage:(UIImage*)image;
@end
