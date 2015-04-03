//
//  KADataModelCookingStep.h
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"

@interface KADataModelCookingStep : NSObject

// designated init
- (id)initWithParsedCookingStepDictionary:(NSDictionary *)dictionary;

@property (nonatomic, assign) NSInteger cookingStep;
@property (nonatomic, strong) NSString *cookingStepDescription;

@end
