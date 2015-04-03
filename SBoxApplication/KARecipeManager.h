//
//  KARecipeManager.h
//  Kochabo
//
//  Created by Botond Kis on 23.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KADataModelRecipe.h"
#import "ApplicationManager.h"

/* ---------------------------------------------
 Notification Keys
 */

// notification will be thrown when the recipe manager has updated
extern NSString * const kNotificationRecipeManagerUpdated;

// notification will be thrown when the Recipemanager starts a download
extern NSString * const kNotificationRecipeManagerDownloadStarted;

// notification will be thrown when the download of the Recipemanager where changed
extern NSString * const kNotificationRecipeManagerDownloadProgressUpdated;

// notification will be thrown when the Recipemanager finishes a download
extern NSString * const kNotificationRecipeManagerDownloadFinished;

// notification will be thrown when a download failed
extern NSString * const kNotificationRecipeManagerDownloadFailed;




/* =======================================================================
 The KARecipeManager handles and stores the Data returned by the Kochabo API
 
 Uses the singleton pattern
 */
@interface KARecipeManager : NSObject
// This array holds all recipes
@property (atomic, strong) NSMutableArray *allRecipes;

// ----------------------------------------------
// Returns the instance of the KARecipeManager
+ (KARecipeManager *) sharedRecipeManager;

// updater
- (void)updateAllRecipesWithCompletition:(void(^)())completitionBlock;

// resetter
// deletes all entries and resets the manager
- (void)resetAllRecipes;

// ----------------------------------------------
// Data accessors
- (void)getAllRecipesWithCompletitionBlock:(void(^)(NSArray *recipes))completitionBlock;
- (void)getAllRecipesForWeek:(NSInteger)week ofYear:(NSInteger)year andCompletitionBlock:(void(^)(NSArray *recipes))completitionBlock;
- (void)getRecipeWithID:(NSString *)recipeID andCompletitionBlock:(void(^)(KADataModelRecipe *recipe))completitionBlock;

// search
- (void)searchForRecipesWithSearchText:(NSString *)searchText andCompletitionBlock:(void(^)(NSArray *recipes))completitionBlock;
@end
