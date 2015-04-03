//
//  HealthstreamEventItem.h
//  SBoxApplication
//
//  Created by snowkrash on 31.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Parse/Parse.h>

@interface HealthstreamEventItem : PFObject
@property (nonatomic, strong) PFObject *event; 
@end
