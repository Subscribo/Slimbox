//
//  RASignal.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 26.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "RACSignal.h"
#import <ReactiveCocoa.h>

@interface RASignal : RACSubject

@property (nonatomic, strong) NSMutableDictionary *views;


@end
