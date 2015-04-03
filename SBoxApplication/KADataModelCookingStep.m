//
//  KADataModelCookingStep.m
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KADataModelCookingStep.h"

@implementation KADataModelCookingStep

- (id)initWithParsedCookingStepDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        
        // parse step
        NSNumber *step = [dictionary objectForKey:@"step"];
        if (objectIsNil(step)) {
            step = @0;
        }
        self.cookingStep  = [step integerValue];
        
        // description
        NSString *description = [dictionary objectForKey:@"description"];
        if (objectIsNil(description)) {
            description = @"";
        }
        self.cookingStepDescription = description;
    }
    
    return self;
}

@end
