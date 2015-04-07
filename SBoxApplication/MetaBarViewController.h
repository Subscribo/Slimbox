//
//  MetaBarViewController.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 11.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <ReactiveCocoa.h>

typedef enum
{
    MetabarControllerAnimationMoveIn,
    MetaBarControllerAnimationMoveOut,
    MetaBarControllerAnimationFadeIn,
    MetaBarControllerAnimationFadeOut
} MetaBarControllerAnimation;

@protocol MetaBarDelegateController <NSObject>
@required
- (void)initMetaBar;
@end

@interface MetaBarViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIView *rightButtonRight; // Icon-Button for Action
@property (nonatomic, strong) IBOutlet UIView *rightButtonLeft; // Icon-Button for Action
@property (nonatomic, strong) IBOutlet UIView *leftButton; // MetaMenuButton
@property (nonatomic, strong) IBOutlet UILabel *titleLabel; // Title

SingletonInit
- (float)getHeight;
- (IBAction)openMenuButton:(id)sender;
- (RACSignal*)setButtonForRightButtonRight:(UIButton *)rightButtonRight;
- (RACSignal*)setButtonForRightButtonLeft:(UIButton *)rightButtonLeft;
- (RACSignal*)setLeftButtonLeft:(UIButton *)leftButton;
- (void)setTitle:(NSString *)titleText;
- (void)showRightButtonLeft:(BOOL)left showRightButtonRight:(BOOL)right;
- (void)pushViewController:(id<MetaBarDelegateController>)controller;
- (void)popViewController;
- (void)setPushAnimation:(MetaBarControllerAnimation)type;
- (void)setPopAnimation:(MetaBarControllerAnimation)type;
@end
