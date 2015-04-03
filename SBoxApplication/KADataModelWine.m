//
//  KADataModelWine.m
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KADataModelWine.h"

@implementation KADataModelWine

- (id)initWithParsedWineDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        
        // parse name
        NSString *name = [dictionary objectForKey:@"name"];
        if (objectIsNil(name)) {
            return nil;
        }
        self.wineName = name;
        
        // description
        NSString *description = [dictionary objectForKey:@"description"];
        if (objectIsNil(description)) {
            description = @"";
        }
        self.wineDescription = description;
        
        // description
        NSString *image = [dictionary objectForKey:@"image"];
        if (objectIsNil(image)) {
            image = @"";
        }
        self.wineImageURL = image;
    }
    
    return self;
}

@end
