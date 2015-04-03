//
//  KADataModelIngredient.h
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"

@interface KADataModelIngredient : NSObject

// designated initalizer
- (id)initWithParsedIngredientDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *ingredientName;
@property (nonatomic, assign) float ingredientQuantity;
@property (nonatomic, strong) NSString *ingredientQuantityUnit;
@property (nonatomic, strong) NSString *ingredientQuantityUnitPlural;
@property (nonatomic, assign) NSInteger ingredientNumberOfPersons;
@property (nonatomic, assign) BOOL ingredientIsDeliverable;

@end
