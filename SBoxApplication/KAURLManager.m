//
//  KAURLManager.m
//  Kochabo
//
//  Created by Botond Kis on 26.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KAURLManager.h"
#import "KASettingsManager.h"

@implementation KAURLManager
// ============================================================
#pragma mark - API URLs
// ============================================================

#define URLBaseUrlAT    @"https://secure.kochabo.at"
#define URLBaseUrlDE    @"https://secure.kochabo.de"

#define KochAboAPI_Key  @"4efa2e5d47f226d3bfc54a9083a0a3a3"

// ------------------------------------
#pragma mark Base URLS
// ------------------------------------
+ (NSString*) getBaseURLStringForUserRegion{
    NSString *baseURL = nil;
    
    switch ([KASettingsManager sharedSettingsManager].userRegion) {
        case KASettingsRegionAustria:
            baseURL = URLBaseUrlAT;
            break;
        case KASettingsRegionGermany:
            baseURL = URLBaseUrlDE;
            break;
            
        default:
            break;
    }
    
    return baseURL;
}

+ (NSString *)stringByAppendKochAboAPIKeyToString:(NSString *)s{
    NSString *retString = nil;
    if ([s rangeOfString:@"?"].location == NSNotFound) {
        retString = [s stringByAppendingFormat:@"?api_key%@", KochAboAPI_Key];
    } else {
        retString = [s stringByAppendingFormat:@"&api_key%@", KochAboAPI_Key];
    }
    
    return retString;
}

// ------------------------------------
#pragma mark Recipes
// ------------------------------------

+ (NSURL*) getRecipeURLForAllRecipes{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingString:@"/api/recipes.php?type=all"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getRecipeURLForAllCurrentRecipes{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingString:@"/api/recipes.php?type=current"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getRecipeURLForAllNextRecipes{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingString:@"/api/recipes.php?type=next"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getRecipeURLForAllRecipesForCalendarWeek:(NSInteger) calendarWeek andYear:(NSInteger) year{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/recipes.php?type=cw&week=%li&year=%li", (long)calendarWeek, (long)year];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getRecipeURLWithSearchString:(NSString *) searchString{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/recipes.php?search=%@", searchString];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getRecipeURLWithID:(NSString *) recipeID{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/recipes.php?id=%@", recipeID];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}


// ------------------------------------
#pragma mark Products
// ------------------------------------

+ (NSURL*) getProductURLForAllProducts{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/products.php"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}


// ------------------------------------
#pragma mark Checkout
// ------------------------------------

+ (NSURL*) getClearCartURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/index.php/kochabo/ajax/clearCart"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}


// ------------------------------------
#pragma mark Tipp of the day
// ------------------------------------

+ (NSURL*) getRandomTippOfTheDayURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/tipOfTheDay.php"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getRandomVeggieTippOfTheDayURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/tipOfTheDay.php?type=veggie"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}


// ------------------------------------
#pragma mark Login
// ------------------------------------

+ (NSURL*) getUserLoginURLWithUserName:(NSString *)userName andPassword:(NSString *)pw{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/kochabo.php?method=login&email=%@&password=%@", userName, pw];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getUserLogoutURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/kochabo.php?method=logout"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getUserStatusURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/kochabo.php?method=isLoggedIn"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getUserNameURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/kochabo.php?method=getCustomerName"];
    
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getForgotPasswordURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/customer/account/forgotPassword/"];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*) getAccountURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/customer/account"];
    
    return [NSURL URLWithString:urlString];
}


// ------------------------------------
#pragma mark sharing
// ------------------------------------

+ (NSURL*) getRecipeShareURLWithID:(NSString *) recipeID{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/kochabo/index/recipedetail/id/%@/", recipeID];
    
    return [NSURL URLWithString:urlString];
}

// ------------------------------------
// email verification
+ (NSURL*) getFacebookUserVerificationURL{
    NSString *urlString = [KAURLManager getBaseURLStringForUserRegion];
    urlString = [urlString stringByAppendingFormat:@"/api/facebook.php"];
    urlString = [self stringByAppendKochAboAPIKeyToString:urlString];
    
    return [NSURL URLWithString:urlString];
}
@end
