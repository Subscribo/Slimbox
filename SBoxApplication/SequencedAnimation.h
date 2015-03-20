//
//  SequencedAnimation.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

@interface SequencedAnimation : NSObject

@property (nonatomic, strong) NSMutableDictionary *viewsWithName;

- (void)test;
- (void)addSubscriber:(void(^)(id))next;
- (void)sendSignal;
- (void)blub;
@end
