//
//  PNutration.h
//  SBoxApplication
//
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Parse/Parse.h>
@interface PHealthstreamEventNutrition : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSNumber *rating;
@property (nonatomic, strong) NSNumber *calories;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *recipeID;
@property (nonatomic, strong) NSString *buttonType;
@end
