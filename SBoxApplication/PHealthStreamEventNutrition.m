//
//  PNutration.m
//  SBoxApplication
//
//
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "PHealthstreamEventNutrition.h"


@implementation PHealthstreamEventNutrition

@dynamic eventID;
@dynamic image;
@dynamic title;
@dynamic rating;
@dynamic calories;
@dynamic recipeID;
@dynamic buttonType;
@dynamic timestamp;

+ (NSString *)parseClassName {
    return @"PHealthstreamEventNutrition";
}

@end
