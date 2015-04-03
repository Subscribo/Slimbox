//
//  SBLoginViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <POP.h>

/**
 Basically a collection of animation tools for views and motion patterns. 
 */
@interface Animation : NSObject
{
    NSArray *configurations;
	NSDictionary *currentConfiguration;
}
+ (void)zoom:(id)animationObject duration:(int)duration from:(double)from to:(double)to;
+ (void)moveX:(id)animationObject duration:(int)valueDuration from:(double)from to:(double)to delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID;


+ (void)moveX:(id)animationObject duration:(int)valueDuration delay:(double)delay from:(double)from to:(double)to delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID;
+ (CALayer*)getLayer:(id)object;
+ (void)fadeIn:(id)animationObject duration:(int)valueDuration completionBlock:(void(^)(POPAnimation *anim, BOOL finished))block;
+ (void)fadeOut:(id)animationObject duration:(int)valueDuration completionBlock:(void(^)(POPAnimation *anim, BOOL finished))block;
+ (void)move:(CALayer*)theLayer from:(CGPoint)fromPoint to:(CGPoint)toPoint duration:(int)valueDuration easing:(int)easingIndex delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID;
+ (void)moveY:(CALayer*)theLayer from:(double)fromPoint to:(double)toPoint duration:(int)valueDuration easing:(int)easingIndex delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID;
+ (void)moveY1:(CALayer*)theLayer from:(double)fromPoint to:(double)toPoint duration:(int)valueDuration easing:(int)easingIndex delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID;
+ (void)rotate:(CALayer*)theLayer removeAnimations:(BOOL)remove duration:(float)duration delegate:(NSObject*)delegate animationID:(NSString*)theAnimationID;
+ (void)rotateY180:(CALayer*)theLayer removeAnimations:(BOOL)remove duration:(float)duration delegate:(NSObject*)delegate animationID:(NSString*)theAnimationID;
+ (void)zoomIn:(CALayer*)theLayer removeAnimations:(BOOL)remove duration:(float)duration delegate:(NSObject*)delegate animationID:(NSString*)theAnimationID;
+ (void)zoomInAndRotate:(CALayer*)theLayer removeAnimations:(BOOL)remove duration:(float)duration delegate:(NSObject*)delegate animationID:(NSString*)theAnimationID;
+ (void)zoomOut:(CALayer*)theLayer removeAnimations:(BOOL)remove duration:(float)duration delegate:(NSObject*)delegate animationID:(NSString*)theAnimationID;
+ (void)initAnimationWithPath:(NSString*)thePath forLayer:(CALayer*)theLayer from:(float)valueFrom to:(float)valueTo duration:(int)valueDuration timing:(int)indexTimer delegate:(NSObject*)theDelegate animationID:(NSString*)theAnimationID;
    + (CAMediaTimingFunction*)getTimerForIndex:(int)index;
    + (void)initAccelerationYAnimationWithPath:(NSString*)thePath forLayer:(CALayer*)theLayer fromY:(double)valueFrom toY:(double)valueTo duration:(int)valueDuration timing:(int)indexTimer delegate:(NSObject*)theDelegate animationID:(NSString*)theAnimationID;
    + (void)initAccelerationYAnimationWithPath1:(NSString*)thePath forLayer:(CALayer*)theLayer fromY:(double)valueFrom toY:(double)valueTo duration:(int)valueDuration timing:(int)indexTimer delegate:(NSObject*)theDelegate animationID:(NSString*)theAnimationID;
+ (void)moveX:(id)animationObject duration:(int)valueDuration from:(double)from to:(double)to completionBlock:(void(^)(POPAnimation *anim, BOOL finished))block;
+ (void)moveOutViews:(NSArray*)views option:(id)option delay:(id)delay completionBlock:(void(^)())block;
+ (void)moveInViews:(NSArray*)views option:(id)option delay:(id)delay x:(double)x y:(double)y;
@end
