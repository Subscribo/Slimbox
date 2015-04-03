//
//  KAURLManager.h
//  Kochabo
//
//  Created by Botond Kis on 26.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"
// Timeout
#ifndef URLRequestTimeOutInterval
#define URLRequestTimeOutInterval 20.0f
#endif

/* =======================================================================
 The KAURLManager stores all API URLs and handles region dependency
 */
@interface KAURLManager : NSObject

// ------------------------------------
// Base URLs
+ (NSString*) getBaseURLStringForUserRegion;
+ (NSString *)stringByAppendKochAboAPIKeyToString:(NSString *)s;

// ------------------------------------
// Recipes
+ (NSURL*) getRecipeURLForAllRecipes;

+ (NSURL*) getRecipeURLForAllCurrentRecipes;

+ (NSURL*) getRecipeURLForAllNextRecipes;

+ (NSURL*) getRecipeURLForAllRecipesForCalendarWeek:(NSInteger) calendarWeek andYear:(NSInteger) year;

+ (NSURL*) getRecipeURLWithSearchString:(NSString *) searchString;

+ (NSURL*) getRecipeURLWithID:(NSString *) recipeID;


// ------------------------------------
// Products
+ (NSURL*) getProductURLForAllProducts;

// ------------------------------------
// Checkout
+ (NSURL*) getClearCartURL;

// ------------------------------------
// Base Tipp of the day
+ (NSURL*) getRandomTippOfTheDayURL;

+ (NSURL*) getRandomVeggieTippOfTheDayURL;

// ------------------------------------
// Login
+ (NSURL*) getUserLoginURLWithUserName:(NSString *)userName andPassword:(NSString *)pw;

+ (NSURL*) getUserLogoutURL;

+ (NSURL*) getUserStatusURL;

+ (NSURL*) getUserNameURL;

+ (NSURL*) getForgotPasswordURL;

+ (NSURL*) getAccountURL;

// ------------------------------------
// Sharing
+ (NSURL*) getRecipeShareURLWithID:(NSString *) recipeID;

// ------------------------------------
// facebook verification
+ (NSURL*) getFacebookUserVerificationURL;

@end
