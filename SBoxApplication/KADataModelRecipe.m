//
//  KADataModelRecipe.m
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KADataModelRecipe.h"

// Models
#import "KADataModelIngredient.h"
#import "KADataModelCookingStep.h"
#import "KADataModelWine.h"


// ==============================================================================
#pragma mark - KADataModelRecipe
// ==============================================================================

@implementation KADataModelRecipe

- (id)initWithParsedRecipeDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        /* --------------------------------
         * do parsing wohooo :D
         * Actually this was a very strict parser where all if(objectIsNil) statements resulted in a return nil;
         * but since the api (Magento) was not able to return reliable data, i've rewrote it so only the id and the name is mandatory.
         */
        
        // get main dict
        NSDictionary *recipeDictionary = dictionary;
        
        // ---------------------------------------------------------
        // content
        self.recipeID = [recipeDictionary objectForKey:@"id"];
        if (objectIsNil(self.recipeID)) {
            return nil;
        }
        
        self.recipeName = [recipeDictionary objectForKey:@"name"];
        if (objectIsNil(self.recipeName)) {
            return nil;
        }
        
        NSString *duration = [recipeDictionary objectForKey:@"duration"];
        if (objectIsNil(duration)) {
            duration = @"0";
        }
        self.recipeDurationinMinutes = [duration integerValue];
        
        
        NSString *boxtype = [recipeDictionary objectForKey:@"boxtype"];
        if (objectIsNil(boxtype)) {
            boxtype = @"0";
        }
        self.recipeBoxType = [boxtype integerValue];
        
        
        NSString *order = [recipeDictionary objectForKey:@"order"];
        if (objectIsNil(order)) {
            order = @"0";
        }
        self.recipeBoxOrder = [order integerValue];
        
        
        NSNumber *isVeggie = [recipeDictionary objectForKey:@"isVeggie"];
        if (objectIsNil(isVeggie)) {
            isVeggie = @NO;
        }
        self.recipeIsVeggie = [isVeggie boolValue];
        
        
        NSString *imageBig = [recipeDictionary objectForKey:@"imageBig"];
        if (objectIsNil(imageBig)) {
            self.recipeImageURLBig = nil;
        }
        self.recipeImageURLBig  = [imageBig stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.recipeImageURLBig  = [imageBig stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *imageMedium = [recipeDictionary objectForKey:@"imageMedium"];
        if (objectIsNil(imageMedium)) {
            self.recipeImageURLMedium = nil;
        }
        self.recipeImageURLMedium  = [imageMedium stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.recipeImageURLMedium  = [imageMedium stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *imageSmall = [recipeDictionary objectForKey:@"imageSmall"];
        if (objectIsNil(imageSmall)) {
            self.recipeImageURLSmall = nil;
        }
        self.recipeImageURLSmall  = [imageSmall stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.recipeImageURLSmall  = [imageSmall stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *image720 = [recipeDictionary objectForKey:@"image720"];
        if (objectIsNil(image720)) {
            image720 = nil;
        }
        self.recipeImageURL720  = [image720 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.recipeImageURL720  = [image720 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSNumber *cw = [recipeDictionary objectForKey:@"cw"];
        if (objectIsNil(cw)) {
            cw = @-1;
        }
        self.recipeCalendarWeek = [cw integerValue];
        
        
        NSNumber *year = [recipeDictionary objectForKey:@"year"];
        if (objectIsNil(year)) {
            year = @-1;
        }
        self.recipeYear = [year integerValue];
        
        
        // ---------------------------------------------------------
        // Details
        
        self.recipeDetails = [[KADataModelRecipeDetails alloc] initWithParsedRecipeDictionary:dictionary];
    }
    
    return self;
}

// override description for debugging
- (NSString*)description{
    return [NSString stringWithFormat:@"Recipe id: %@ \tName: %@ \tisVeggie: %@ - y %li w %li", self.recipeID, self.recipeName, self.recipeIsVeggie?@"YES":@"NO", (long)self.recipeYear, (long)self.recipeCalendarWeek];
}

@end



// ==============================================================================
#pragma mark - KADataModelRecipeDetails
// ==============================================================================
@implementation KADataModelRecipeDetails

- (id)initWithParsedRecipeDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        // --------------------------------
        // get main dict
        NSDictionary *recipeDictionary = dictionary;
        
        
        // ---------------------------------------------------------
        // content        
        NSString *shouldHaveAtHome = [recipeDictionary objectForKey:@"shouldHaveAtHome"];
        self.recipeStuffYouShouldHaveAtHome  = shouldHaveAtHome;
        
        
        NSString *cookingAdvice = [recipeDictionary objectForKey:@"cookingAdvice"];
        self.recipeCookingAdvice  = cookingAdvice;
        
        
        NSNumber *carbonhydrate = [recipeDictionary objectForKey:@"carbonhydrate"];
        self.recipeCarbonhydrateInGramms  = [carbonhydrate integerValue];
        
        
        NSNumber *protein = [recipeDictionary objectForKey:@"protein"];
        self.recipeProteinInGramms  = [protein integerValue];
        
        
        NSNumber *fat = [recipeDictionary objectForKey:@"fat"];
        self.recipeFatInGramms  = [fat integerValue];
        
        
        NSNumber *energyValue = [recipeDictionary objectForKey:@"energyValue"];
        self.recipeEnergyValueInKcal  = [energyValue integerValue];
        
        
        NSNumber *isGlutenFree = [recipeDictionary objectForKey:@"isGlutenFree"];
        self.recipeIsGlutenFree  = [isGlutenFree boolValue];
        
        
        NSNumber *isLactoseFree = [recipeDictionary objectForKey:@"isLactoseFree"];
        self.recipeIsLactoseFree  = [isLactoseFree boolValue];
        
        
        NSNumber *isVegetarian = [recipeDictionary objectForKey:@"isVegetarian"];
        self.recipeIsVegetarian  = [isVegetarian boolValue];
        
        
        NSNumber *isMeat = [recipeDictionary objectForKey:@"isMeat"];
        self.recipeIsMeat  = [isMeat boolValue];
        
        
        NSNumber *isFish = [recipeDictionary objectForKey:@"isFish"];
        self.recipeIsFish  = [isFish boolValue];
        
        // ---------------------------------------------------------
        // Cooking Steps
        NSArray *cookingStepsDict = [recipeDictionary objectForKey:@"cookingSteps"];
        if (!objectIsNil(cookingStepsDict)) {
            NSMutableArray *cookingSteps = [[NSMutableArray alloc] initWithCapacity:5];
            
            for (NSDictionary *stepDict in cookingStepsDict) {
                KADataModelCookingStep *step = [[KADataModelCookingStep alloc] initWithParsedCookingStepDictionary:stepDict];
                if (step) {
                    [cookingSteps addObject:step];
                }
            }
            
            self.recipeCookingSteps = cookingSteps;
        }
        
        // sort steps
        self.recipeCookingSteps = [self.recipeCookingSteps sortedArrayUsingComparator:^NSComparisonResult(KADataModelCookingStep *obj1, KADataModelCookingStep *obj2) {
            NSComparisonResult result = NSOrderedSame;
            
            if (obj1.cookingStep > obj2.cookingStep) {
                result = NSOrderedDescending;
            }else{
                result = NSOrderedAscending;
            }
            
            return result;
        }];
        
        
        // ---------------------------------------------------------
        // ingredients
        NSMutableSet *noOfPersons = [[NSMutableSet alloc] init];
        
        NSArray *ingredientsDict = [recipeDictionary objectForKey:@"ingredients"];
        if (!objectIsNil(ingredientsDict)) {
            NSMutableArray *ingredients = [[NSMutableArray alloc] init];
            
            for (NSDictionary *ingredientDict in ingredientsDict) {
                KADataModelIngredient *ingredient = [[KADataModelIngredient alloc] initWithParsedIngredientDictionary:ingredientDict];
                if (ingredient) {
                    [noOfPersons addObject: [NSNumber numberWithInteger:ingredient.ingredientNumberOfPersons]];
                    [ingredients addObject:ingredient];
                }
            }
            
            self.recipeIngredients = ingredients;
        }
        self.recipeNumberOfPersons = [noOfPersons allObjects];
        
        // ---------------------------------------------------------
        // Wine
        NSDictionary *wineDict = [recipeDictionary objectForKey:@"wine"];
        if (!objectIsNil(wineDict)) {
            KADataModelWine *wine = [[KADataModelWine alloc] initWithParsedWineDictionary:wineDict];
            self.recipeWine = wine;
        }
    }
    
    return self;
}


- (NSArray *)ingredientsForPersons:(NSInteger)numberOfPersons{
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    
    for (KADataModelIngredient *ingredient in self.recipeIngredients) {
        if (ingredient.ingredientNumberOfPersons == numberOfPersons) {
            [ingredients addObject:ingredient];
        }
    }
    
    return ingredients;
}

- (BOOL)nutritionAvailable{
   return (self.recipeCarbonhydrateInGramms + self.recipeProteinInGramms + self.recipeFatInGramms + self.recipeEnergyValueInKcal) > 3;
}

@end
