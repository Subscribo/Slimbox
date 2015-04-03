//
//  KADataModelWine.h
//  Kochabo
//
//  Created by Botond Kis on 24.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"

@interface KADataModelWine : NSObject

// designated init
- (id)initWithParsedWineDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *wineName;
@property (nonatomic, strong) NSString *wineDescription;
@property (nonatomic, strong) NSString *wineImageURL;

@end
