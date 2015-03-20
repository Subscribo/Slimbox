//
//  ResourceManager.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 13.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Singletone.h"
@interface ResourceManager : NSObject <CLLocationManagerDelegate>
SINGLETONE


@end