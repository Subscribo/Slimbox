//
//  KADataModelIngredient.m
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KADataModelIngredient.h"

@implementation KADataModelIngredient

- (id)initWithParsedIngredientDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        
        // name
        NSString *name = [dictionary objectForKey:@"name"];
        if (objectIsNil(name)) {
            name = @"";
        }
        self.ingredientName = name;
        
        
        // isDeliverable
        NSNumber *isDeliverable = [dictionary objectForKey:@"isDeliverable"];
        if (objectIsNil(isDeliverable)) {
            isDeliverable = @NO;
        }
        self.ingredientIsDeliverable = [isDeliverable boolValue];
        
        
        // quantity
        NSString *quantity = [dictionary objectForKey:@"quantity"];
        if (objectIsNil(quantity)) {
            quantity = @"0";
        }
        if ([quantity isEqualToString:@""]) {
            quantity = @"-1";
        }

        self.ingredientQuantity = [quantity floatValue];
        
        // Quantity Unit
        NSString *unit = [dictionary objectForKey:@"unit"];
        if (objectIsNil(unit)) {
            unit = @"";
        }
        self.ingredientQuantityUnit = unit;
        
        
        // Quantity Unit plural
        NSString *unitPlural = [dictionary objectForKey:@"unitPlural"];
        if (objectIsNil(unitPlural)) {
            unitPlural = @"";
        }
        self.ingredientQuantityUnitPlural = unitPlural;
        
        
        // nrOfPersons
        NSString *nrOfPersons = [dictionary objectForKey:@"nrOfPersons"];
        if (objectIsNil(nrOfPersons)) {
            unitPlural = @"0";
        }
        self.ingredientNumberOfPersons = [nrOfPersons integerValue];
    }
    
    return self;
}

@end
