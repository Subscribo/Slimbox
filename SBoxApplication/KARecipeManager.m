//
//  KARecipeManager.m
//  Kochabo
//
//  Created by Botond Kis on 23.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KARecipeManager.h"

// Settings
#import "KASettingsManager.h"

// urls
#import "KAURLManager.h"

// Data models
#import "KADataModelRecipe.h"
#import "KADataModelCookingStep.h"
#import "KADataModelIngredient.h"
#import "KADataModelWine.h"

// AFNetworking
#import "AFNetworking.h"


// ============================================================
#pragma mark - Notification Keys
// ============================================================

NSString * const kNotificationRecipeManagerUpdated                    = @"com.notification.recipeManager.updated";
NSString * const kNotificationRecipeManagerDownloadStarted            = @"com.notification.recipeManager.download.started";
NSString * const kNotificationRecipeManagerDownloadFinished           = @"com.notification.recipeManager.download.finished";
NSString * const kNotificationRecipeManagerDownloadFailed             = @"com.notification.recipeManager.download.failed";


// ============================================================
#pragma mark - KARecipeManager
// ============================================================

@interface KARecipeManager ()

- (NSArray *)filteredRecipesIfVeggie:(NSArray *)recipes;

- (void)settingsChanged;

@property (nonatomic, assign) BOOL allRecipesDownloadedAtleastOneTime;

@end

// The single instance of this class
static KARecipeManager *_sharedInstance;

@implementation KARecipeManager

// -----------------------------------------------
#pragma mark - singleton
// -----------------------------------------------

+ (KARecipeManager *) sharedRecipeManager{
    if (!_sharedInstance) {
        _sharedInstance = [[KARecipeManager alloc] init];
    }
    
    return _sharedInstance;
}

// -----------------------------------------------
#pragma mark - Data
// -----------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        _allRecipes = [[NSMutableArray alloc] init];
        self.allRecipesDownloadedAtleastOneTime = NO;
        
        // listen to settings changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged) name:kNotificationSettingsChanged object:nil];
    }
    return self;
}

- (void)dealloc{
    // remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// -----------------------------------------------
#pragma mark - Private
// -----------------------------------------------

- (NSArray *)filteredRecipesIfVeggie:(NSArray *)recipes{
    if ([KASettingsManager sharedSettingsManager].userFoodType == KASettingsFoodTypeVeggie) {
        NSMutableArray *filteredRecipes = [NSMutableArray array];
        [recipes enumerateObjectsUsingBlock:^(KADataModelRecipe *recipe, NSUInteger idx, BOOL *stop) {
            if (recipe.recipeIsVeggie) {
                [filteredRecipes addObject:recipe];
            }
        }];
        return filteredRecipes;
    }else{
        return recipes;
    }
}

- (void)settingsChanged{
    // reset recipes
    [self resetAllRecipes];
}

// -----------------------------------------------
#pragma mark - Data accessors
// -----------------------------------------------

- (void)_addRecipesToCache:(NSArray *)recipes{
    
    // true new recipes
    NSMutableArray *newRecipesToAdd = [NSMutableArray array];
    
    // iterate through all to avoid duplicates
    [recipes enumerateObjectsUsingBlock:^(KADataModelRecipe *recipeToAdd, NSUInteger idx, BOOL *stop) {
        
        // contained flag
        __block BOOL contained = NO;
        [self.allRecipes enumerateObjectsUsingBlock:^(KADataModelRecipe *storedRecipe, NSUInteger idx, BOOL *stop) {
            
            // if ID is contained, drop new recipe
            if ([storedRecipe.recipeID isEqualToString:recipeToAdd.recipeID]) {
                contained = YES;
                storedRecipe.recipeCalendarWeek = recipeToAdd.recipeCalendarWeek;
                storedRecipe.recipeYear = recipeToAdd.recipeYear;
                storedRecipe.recipeIsVeggie = storedRecipe.recipeIsVeggie || recipeToAdd.recipeIsVeggie; // keep veggie flag because backend is too dumb
                *stop = YES;
            }
        }];
        
        // add recipe if it's not contained
        if (!contained) {
            [newRecipesToAdd addObject:recipeToAdd];
        }
    }];
    
    // add true new recipes
    [self.allRecipes addObjectsFromArray:newRecipesToAdd];
}

- (void)getAllRecipesWithCompletitionBlock:(void(^)(NSArray *recipes))completitionBlock{
    
    // if we have recipes return them
    if (self.allRecipesDownloadedAtleastOneTime && self.allRecipes && [self.allRecipes count] > 0) {
        if (completitionBlock) {
            completitionBlock([self filteredRecipesIfVeggie:self.allRecipes]);
        }
    }
    // else download them!
    else{
        [self updateAllRecipesWithCompletition:^{
            if (completitionBlock) {
                completitionBlock([self filteredRecipesIfVeggie:self.allRecipes]);
            }
        }];
    }
}


- (void)getAllRecipesForWeek:(NSInteger)week ofYear:(NSInteger)year andCompletitionBlock:(void(^)(NSArray *recipes))completitionBlock{
    __block NSMutableArray *recipesForWeek = [[NSMutableArray alloc] initWithCapacity:10];
    
    // iterate through all recipes
    [self.allRecipes enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(KADataModelRecipe *recipe, NSUInteger idx, BOOL *stop) {
        if (recipe.recipeCalendarWeek == week && recipe.recipeYear == year) {
            [recipesForWeek addObject:recipe];
        }
    }];
    
    // download if there were no recipes found
    if (recipesForWeek.count <= 0) {
        // make dl request
        NSURLRequest *recipeWeekRequest = [NSURLRequest requestWithURL:[KAURLManager getRecipeURLForAllRecipesForCalendarWeek:week andYear:year]
                                                           cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:URLRequestTimeOutInterval];
        
        // start download
        __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:recipeWeekRequest];
        __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
        requestOperation.completionBlock = ^{
            
            // safety check
            if (requestOperation.responseData == nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    // call completition block
                    completitionBlock(nil);
                });
                
                return;
            }
            
            // do parsing and stuff in a background queue
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // parse json to cocoa
                NSError *err = nil;
                NSDictionary *parsedResponse;
                if (requestOperation.responseData) {
                    parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
                }
                else{
                    // call completition block with nil
                    if (completitionBlock) {
                        completitionBlock(nil);
                    }
                }
                
                if (err) {
                    NSLog(@"Error: %@", err);
                }
                
                // handle error
                if (objectIsNil(parsedResponse)) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Error occured during parsing in getAllRecipesForWeek: \n%ld Year: \n%ld", (long)week, (long)year);
                        
                        // post notification
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                        
                        // call completition block with nil
                        if (completitionBlock) {
                            completitionBlock(nil);
                        }
                    });
                    return;
                }
                
                NSArray *parsedRecipes = [parsedResponse objectForKey:@"recipes"];
                if (objectIsNil(parsedRecipes)) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // post notification
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                        
                        // call completition block with nil
                        if (completitionBlock) {
                            completitionBlock(nil);
                        }
                    });
                    return;
                }
                
                // parse recipes
                __block NSMutableArray *newRecipes = [[NSMutableArray alloc] initWithCapacity:parsedRecipes.count];
                for (NSDictionary *recipeDict in parsedRecipes) {
                    KADataModelRecipe *newRecipe = [[KADataModelRecipe alloc] initWithParsedRecipeDictionary:recipeDict];
                    newRecipe.recipeCalendarWeek = week;
                    newRecipe.recipeYear = year;
                    
                    // check for double IDs
                    __block BOOL isContained = NO;
                    [newRecipes enumerateObjectsUsingBlock:^(KADataModelRecipe *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.recipeID isEqualToString:newRecipe.recipeID]) {
                            isContained = YES;
                            obj.recipeIsVeggie = obj.recipeIsVeggie | newRecipe.recipeIsVeggie;
                            *stop = YES;
                        }
                    }];
                    
                    if (!isContained) {
                        [newRecipes addObject:newRecipe];
                    }
                    
                }
                
                // store and notificate on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // add new recipes to all recipes
                    [self _addRecipesToCache:newRecipes];
                    
                    // call completition block
                    if (completitionBlock) {
                        completitionBlock([self filteredRecipesIfVeggie:newRecipes]);
                    }
                    
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFinished object:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerUpdated object:self];
                });
            });
        };
        
        // post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadStarted object:self];
        
        [requestOperation start];
    }
    // else call completition block with found recipes
    else{
        if (completitionBlock) {
            completitionBlock([self filteredRecipesIfVeggie:recipesForWeek]);
        }
    }
}


- (void)getRecipeWithID:(NSString *)recipeID andCompletitionBlock:(void(^)(KADataModelRecipe *recipe))completitionBlock{
    __block KADataModelRecipe *foundRecipe = nil;
    
    // iterate through all recipes
    [self.allRecipes enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(KADataModelRecipe *recipe, NSUInteger idx, BOOL *stop) {
        if ([recipe.recipeID isEqualToString:recipeID]) {
            // stop when recipe was found
            
            if (!foundRecipe.recipeDetails.recipeCookingSteps) {
                
            }
            else
            {
                foundRecipe = recipe;
                *stop = YES;
            }
        }
    }];
    
    // if there is a recipe but without details, fetch them
    if (!foundRecipe || !foundRecipe.recipeDetails || !foundRecipe.recipeDetails.recipeCookingSteps || !foundRecipe.recipeDetails.recipeIngredients) {
        
        // make dl request
        NSURLRequest *recipeDetailRequest = [NSURLRequest requestWithURL:[KAURLManager getRecipeURLWithID:recipeID]
                                                             cachePolicy:NSURLCacheStorageNotAllowed
                                                         timeoutInterval:URLRequestTimeOutInterval];
        
        // start download
        __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:recipeDetailRequest];
        __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
        requestOperation.completionBlock = ^{
            
            // safety check
            if (requestOperation.responseData == nil) {
                
                // call completition block with nil
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    completitionBlock(nil);
                });
                
                return;
            }
            
            // do parsing and stuff in a background queue
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // parse json to cocoa
                NSError *err = nil;
                NSDictionary *parsedResponse;
                if (requestOperation.responseData) {
                    parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
                }
                else{
                    // call completition block with nil
                    if (completitionBlock) {
                        completitionBlock(nil);
                    }
                }
                
                // handle error
                if (objectIsNil(parsedResponse)) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Error occured during parsing in getRecipeWithID: \n%@", err);
                        
                        // post notification
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                        
                        // call completition block with nil
                        if (completitionBlock) {
                            completitionBlock(nil);
                        }
                    });
                    return;
                }
                
                NSDictionary *parsedRecipeDict = [parsedResponse objectForKey:@"recipe"];
                if (objectIsNil(parsedRecipeDict)) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // post notification
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                        
                        // call completition block with nil
                        if (completitionBlock) {
                            completitionBlock(nil);
                        }
                    });
                    return;
                }
                
                // create detail Object
                __block KADataModelRecipe *newRecipe = [[KADataModelRecipe alloc] initWithParsedRecipeDictionary:parsedRecipeDict];
                
                // store and notificate on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // iterate through all recipes
                    __block BOOL contained = NO;
                    
                    [self.allRecipes enumerateObjectsUsingBlock:^(KADataModelRecipe *recipe, NSUInteger idx, BOOL *stop) {
                        if ([recipe.recipeID isEqualToString:recipeID]) {
                            // break when recipe was found
                            
                            //replace first creation Week and Year values by crcipe current used Year and Week
                            newRecipe.recipeCalendarWeek = recipe.recipeCalendarWeek;
                            newRecipe.recipeYear = recipe.recipeYear;
                            
                            [self.allRecipes replaceObjectAtIndex:[self.allRecipes indexOfObject:recipe] withObject:newRecipe];
                            contained = YES;
                            *stop = YES;
                        }
                    }];
                    
                    if (!contained) {
                        [self _addRecipesToCache:@[newRecipe]];
                    }
                    
                    // call completition block
                    if (completitionBlock) {
                        completitionBlock(newRecipe);
                    }
                    
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFinished object:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerUpdated object:self];
                });
            });
        };
        
        // post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadStarted object:self];
        
        [requestOperation start];
    }
    // if it has details call the completition block
    else{
        if (completitionBlock) {
            completitionBlock(foundRecipe);
        }
    }
}


// -----------------------------------------------
#pragma mark - Search
// -----------------------------------------------

- (void)searchForRecipesWithSearchText:(NSString *)searchText andCompletitionBlock:(void(^)(NSArray *recipes))completitionBlock{
    
    // html encode text
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // make dl request
    NSURLRequest *recipesSearchRequest = [NSURLRequest requestWithURL:[KAURLManager getRecipeURLWithSearchString:searchText]
                                                          cachePolicy:NSURLCacheStorageNotAllowed
                                                      timeoutInterval:URLRequestTimeOutInterval];
    
    // start download
    __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:recipesSearchRequest];
    __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
    requestOperation.completionBlock = ^{
        
        // safety check
        if (requestOperation.responseData == nil) {
            
            // call completition block with nil
            if (completitionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    completitionBlock(nil);
                });
            }
            
            return;
        }
        
        // do parsing and stuff in a background queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // parse json to cocoa
            NSError *err = nil;
            NSDictionary *parsedResponse;
            if (requestOperation.responseData) {
                parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
            }
            else{
                // call completition block with nil
                if (completitionBlock) {
                    completitionBlock(nil);
                }
            }
            
            // handle error
            if (objectIsNil(parsedResponse)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Error occured during parsing in searchForRecipesWithSearchText: \n%@", err);
                    
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    // call completition block with nil
                    if (completitionBlock) {
                        completitionBlock(nil);
                    }
                });
                return;
            }
            
            // parse new recipes
            NSArray *recipes = [parsedResponse objectForKey:@"recipes"];
            if (objectIsNil(recipes)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    // call completition block with nil
                    if (completitionBlock) {
                        completitionBlock(nil);
                    }
                });
                return;
            }
            
            // parse recipes
            __block NSMutableArray *foundRecipes = [[NSMutableArray alloc] init];
            for (NSDictionary *recipeDict in recipes) {
                KADataModelRecipe *newRecipe = [[KADataModelRecipe alloc] initWithParsedRecipeDictionary:recipeDict];
                
                // check for double IDs
                __block BOOL isContained = NO;
                [foundRecipes enumerateObjectsUsingBlock:^(KADataModelRecipe *obj, NSUInteger idx, BOOL *stop) {
                    if ([obj.recipeID isEqualToString:newRecipe.recipeID]) {
                        isContained = YES;
                        obj.recipeIsVeggie = obj.recipeIsVeggie || newRecipe.recipeIsVeggie;
                        *stop = YES;
                    }
                }];
                
                if (!isContained) {
                    [foundRecipes addObject:newRecipe];
                }
                
            }
            
            // store and notificate on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // call completition block
                if (completitionBlock) {
                    completitionBlock(foundRecipes);
                }
                
                // post notification
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFinished object:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerUpdated object:self];
            });
        });
    };
    
    // post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadStarted object:self];
    
    [requestOperation start];
}


// -----------------------------------------------
#pragma mark - Updater
// -----------------------------------------------

- (void)updateAllRecipesWithCompletition:(void(^)())completitionBlock{
    
    // make dl request
    NSURLRequest *recipesRequest = [NSURLRequest requestWithURL:[KAURLManager getRecipeURLForAllRecipes]
                                                    cachePolicy:NSURLCacheStorageNotAllowed
                                                timeoutInterval:URLRequestTimeOutInterval];
    
    // start download
    __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:recipesRequest];
    __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
    requestOperation.completionBlock = ^{
        
        // safety check
        if (requestOperation.responseData == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // post notification
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                
                // call completition block
                completitionBlock();
            });
            
            return;
        }
        
        // do parsing and stuff in a background queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // parse json to cocoa
            NSError *err = nil;
            NSDictionary *parsedResponse;
            if (requestOperation.responseData) {
                parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
            }
            else{
                // call completition block with nil
                if (completitionBlock) {
                    completitionBlock(nil);
                }
            }
            
            // handle error
            if (objectIsNil(parsedResponse)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Error occured during parsing in updateAllRecipesWithCompletition: \n%@", err);
                    
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    // call completition block with nil
                    if (completitionBlock) {
                        completitionBlock();
                    }
                });
                return;
            }
            
            // parse new recipes
            NSArray *recipes = [parsedResponse objectForKey:@"recipes"];
            if (objectIsNil(recipes)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFailed object:self];
                    
                    // call completition block with nil
                    if (completitionBlock) {
                        completitionBlock();
                    }
                });
                return;
            }
            
            // parse recipes
            __block NSMutableArray *newRecipes = [[NSMutableArray alloc] initWithCapacity:self.allRecipes.count];
            for (NSDictionary *recipeDict in recipes) {
                KADataModelRecipe *newRecipe = [[KADataModelRecipe alloc] initWithParsedRecipeDictionary:recipeDict];
                newRecipe.recipeYear = -1;
                newRecipe.recipeCalendarWeek = -1;
                
                // check for double IDs
                __block BOOL isContained = NO;
                [newRecipes enumerateObjectsUsingBlock:^(KADataModelRecipe *obj, NSUInteger idx, BOOL *stop) {
                    if ([obj.recipeID isEqualToString:newRecipe.recipeID]) {
                        isContained = YES;
                        obj.recipeIsVeggie = obj.recipeIsVeggie | newRecipe.recipeIsVeggie;
                        *stop = YES;
                    }
                }];
                
                if (!isContained) {
                    [newRecipes addObject:newRecipe];
                }
                
            }
            
            // store and notificate on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                // update flag
                self.allRecipesDownloadedAtleastOneTime = YES;
                
                // save new recipes
                [self.allRecipes removeAllObjects];
                [self _addRecipesToCache:newRecipes];
                
                // call completition block
                if (completitionBlock) {
                    completitionBlock();
                }
                
                // post notification
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadFinished object:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerUpdated object:self];
            });
        });
    };
    
    // post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerDownloadStarted object:self];
    
    [requestOperation start];
}

- (void)resetAllRecipes{
    // update flag
    self.allRecipesDownloadedAtleastOneTime = NO;
    
    // remove all recipes
    [self.allRecipes removeAllObjects];
    
    // post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecipeManagerUpdated object:self];
}

@end
