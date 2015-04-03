//
//  KADataModelRecipe.h
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"

// sub models
#import "KADataModelCookingStep.h"
#import "KADataModelIngredient.h"
#import "KADataModelWine.h"

@class KADataModelRecipeDetails;

// -------------------------------------------------------
// Recipe holds the basic recipe info returned by
// all API calls which return an array of recipes
// -------------------------------------------------------

@interface KADataModelRecipe : NSObject

// designated initializer
- (id)initWithParsedRecipeDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *recipeID;
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, assign) NSInteger recipeDurationinMinutes;
@property (nonatomic, assign) NSInteger recipeBoxType;
@property (nonatomic, assign) NSInteger recipeBoxOrder;
@property (nonatomic, assign) BOOL recipeIsVeggie;
@property (nonatomic, strong) NSString *recipeImageURLBig;
@property (nonatomic, strong) NSString *recipeImageURLMedium;
@property (nonatomic, strong) NSString *recipeImageURLSmall;
@property (nonatomic, strong) NSString *recipeImageURL720;
@property (nonatomic, assign) NSInteger recipeCalendarWeek;
@property (nonatomic, assign) NSInteger recipeYear;
@property (nonatomic, strong) KADataModelRecipeDetails *recipeDetails;

@end


// -------------------------------------------------------
// RecipeDetail holds all additional info about a
// recipe returned by the ?id= API call
// -------------------------------------------------------

@interface KADataModelRecipeDetails : NSObject;

// designated initializer
- (id)initWithParsedRecipeDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *recipeStuffYouShouldHaveAtHome; // Comma separated String
@property (nonatomic, strong) NSString *recipeCookingAdvice;
@property (nonatomic, strong) NSArray  *recipeCookingSteps;     // Array of KADataModelCookingStep
@property (nonatomic, assign) NSInteger recipeCarbonhydrateInGramms;
@property (nonatomic, assign) NSInteger recipeProteinInGramms;
@property (nonatomic, assign) NSInteger recipeFatInGramms;
@property (nonatomic, assign) NSInteger recipeEnergyValueInKcal;
@property (nonatomic, assign) BOOL recipeIsGlutenFree;
@property (nonatomic, assign) BOOL recipeIsLactoseFree;
@property (nonatomic, assign) BOOL recipeIsVegetarian;
@property (nonatomic, assign) BOOL recipeIsMeat;
@property (nonatomic, assign) BOOL recipeIsFish;
@property (nonatomic, strong) KADataModelWine *recipeWine;
@property (nonatomic, strong) NSArray *recipeIngredients;       // Array of KADataModelIngredient
@property (nonatomic, strong) NSArray *recipeNumberOfPersons;   // Array with NSNumbers

- (NSArray *)ingredientsForPersons:(NSInteger)numberOfPersons;

- (BOOL)nutritionAvailable;

@end
