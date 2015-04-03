//
//  PHealthStreamEvent.m
//  SBoxApplication
//
//
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "PHealthstreamEvent.h"

@implementation PHealthstreamEvent
@dynamic eventID;
@dynamic type;
@dynamic timestamp;

+ (NSString *)parseClassName {
    return @"PHealthstreamEvent";
}
@end
