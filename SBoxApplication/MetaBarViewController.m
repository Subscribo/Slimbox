//
//  MetaBarViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 11.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "MetaBarViewController.h"
#import "SBNotifications.h"
@interface MetaBarViewController ()

@end

@implementation MetaBarViewController
Singleton(MetaBarViewController)

/**
 */
- (instancetype)initSingleton
{
    return self;
}

/**
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*#t:
 - (void)show:(BOOL)show;
 - (void)addIcon:(UIView*)icon target:(Selector)target option:(kMetabarOption)option animated:(BOOL)animated;
 
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 */
- (IBAction)openMenuButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyOpenMetaMenu object:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyOpenMetaMenu object:self];
}

/**
 Return height.
 */
- (float)getHeight
{
    return 50.0f;
}

- (RACSignal*)setButtonForRightButtonRight:(UIButton *)rightButtonRight
{
    if (!rightButtonRight)
    {
        for (UIView *subview in self.rightButtonRight.subviews)
        {
            [subview removeFromSuperview];
        }
        return nil;
    }

    rightButtonRight.frame = CGRectMake(0, 0, self.rightButtonRight.frame.size.width, self.rightButtonRight.frame.size.height);
    self.rightButtonRight.backgroundColor = [UIColor greenColor];
    [self.rightButtonRight addSubview:rightButtonRight];
    return [rightButtonRight rac_signalForControlEvents:UIControlEventTouchUpInside];
}

- (RACSignal*)setButtonForRightButtonLeft:(UIButton *)rightButtonLeft
{
    if (!rightButtonLeft)
    {
        for (UIView *subview in self.rightButtonLeft.subviews)
        {
            [subview removeFromSuperview];
        }
        return nil;
    }
    rightButtonLeft.frame = self.rightButtonLeft.frame;
    [self.rightButtonLeft addSubview:rightButtonLeft];
    return [rightButtonLeft rac_signalForControlEvents:UIControlEventTouchDown];
}


- (RACSignal*)setLeftButtonLeft:(UIButton *)leftButton;

{
    if (!leftButton)
    {
        for (UIView *subview in self.leftButton.subviews)
        {
            [subview removeFromSuperview];
        }
        return nil;
    }
    leftButton.frame = self.leftButton.frame;
    [self.leftButton addSubview:leftButton];
    return [leftButton rac_signalForControlEvents:UIControlEventTouchDown];
}

/**
 */
- (void)setTitle:(NSString *)titleText
{
    if (!titleText)
    {
        self.titleLabel.text = @"";
    }
    else
    {
        self.titleLabel.text = titleText;
    }
}


@end
