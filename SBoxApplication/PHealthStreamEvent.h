//
//  PHealthStreamEvent.h
//  SBoxApplication
//
//
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Parse/Parse.h>

@interface PHealthstreamEvent : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *type; 
@property (nonatomic, strong) NSDate *timestamp;

@end
