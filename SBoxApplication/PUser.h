//
//  PUser.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 09.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Parse/Parse.h>
@interface PUser : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *postalcode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *bodysize;
@property (nonatomic, strong) NSNumber *bodyweight;
@property (nonatomic, strong) NSDate *birthdate;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *twitterID;
@property (nonatomic, strong) NSString *emailID;
@property (nonatomic, strong) NSNumber *registerType;
@property (nonatomic, strong) PFUser *parseUser;

+ (NSString *)parseClassName;

@end

