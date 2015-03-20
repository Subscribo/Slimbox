//
//  SBLoginViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "Animation.h"
#import "AccelerationAnimation.h"
#import "ApplicationManager.h"
#import "Evaluate.h"
#import <UIKit/UIKit.h>
#import <POP.h>

@implementation Animation

#pragma mark - Animation Methods


+ (CALayer*)getLayer:(id)object
{
    if ([object isKindOfClass:[UIView class]]) {
        return ((UIView*)object).layer;
    }
    else if ([object isKindOfClass:[CALayer class]])
    {
        return object;
    }
    return nil;
}

/**
 Fades in any layer.
 */
+ (void)fadeIn:(id)animationObject duration:(int)valueDuration completionBlock:(void(^)(POPAnimation *anim, BOOL finished))block
{
    {
        POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        spin.fromValue = @(0);
        spin.toValue = @(1);
        spin.springBounciness = 0;
        spin.completionBlock = block;
        spin.velocity = @(valueDuration);
        [[Animation getLayer:animationObject] pop_addAnimation:spin forKey:@""];
    }
}

/**
 Fades in any layer.
 */
+ (void)fadeOut:(id)animationObject duration:(int)valueDuration completionBlock:(void(^)(POPAnimation *anim, BOOL finished))block
{
    POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    spin.fromValue = @(1);
    spin.toValue = @(0);
    spin.springBounciness = 0;
    spin.completionBlock = block;
    spin.velocity = @(valueDuration);
    [[Animation getLayer:animationObject] pop_addAnimation:spin forKey:@""];
}


/**
 Fades in any layer.
 */
+ (void)moveX:(id)animationObject duration:(int)valueDuration from:(double)from to:(double)to delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(from);
    anim.toValue = @(to);
    anim.duration =valueDuration;
    [[Animation getLayer:animationObject] pop_addAnimation:anim forKey:@""];
}

/**
 Fades in any layer.
 */
+ (void)moveX:(id)animationObject duration:(int)valueDuration from:(double)from to:(double)to completionBlock:(void(^)(POPAnimation *anim, BOOL finished))block
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(from);
    anim.toValue = @(to);
    anim.completionBlock = block;
    anim.duration =valueDuration;
    [[Animation getLayer:animationObject] pop_addAnimation:anim forKey:@""];
}

/**
 */
+ (void)moveOutViews:(NSArray*)views option:(id)option delay:(id)delay completionBlock:(void(^)())block
{
    for (UIView *v in views)
    {
        [Animation moveX:v duration:2 from:v.frame.origin.x to:-[ApplicationManager getScreenWidth]*2 completionBlock:^(POPAnimation *anim, BOOL finished){
            [v removeFromSuperview];
            block();
        }];
    }
}

+ (void)moveInViews:(NSArray*)views option:(id)option delay:(id)delay x:(double)x y:(double)y
{
    for (UIView *v in views)
    {
        [Animation moveX:v duration:2 from:v.frame.origin.x to:x completionBlock:^(POPAnimation *anim, BOOL finished){
            //[v removeFromSuperview];
        }];
    }
}


/**
 Fades in any layer.
 */
+ (void)moveX:(id)animationObject duration:(int)valueDuration delay:(double)deilay from:(double)from to:(double)to delegate:(NSObject *)theDelegate animationID:(NSString*)theAnimationID
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(from);
    anim.beginTime = CACurrentMediaTime()+5;
    anim.toValue = @(to);
    anim.duration =valueDuration;
    [[Animation getLayer:animationObject] pop_addAnimation:anim forKey:@""];
}


/**
 Zoom Layer.
 */
+ (void)zoom:(id)animationObject duration:(int)duration from:(double)from to:(double)to
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    anim.duration = 40;
    [[Animation getLayer:animationObject] pop_addAnimation:anim forKey:@""];
}

@end
