//
//  PUser.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 09.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "PUser.h"

@implementation PUser
@dynamic name;
@dynamic surname;
@dynamic gender;
@dynamic street;
@dynamic postalcode;
@dynamic country;
@dynamic email;
@dynamic bodysize;
@dynamic bodyweight;
@dynamic birthdate;
@dynamic facebookID;
@dynamic twitterID;
@dynamic emailID;
@dynamic registerType;
@dynamic parseUser;

+ (NSString *)parseClassName {
    return @"PUser";
}
@end
