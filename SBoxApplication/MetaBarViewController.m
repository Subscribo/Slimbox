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
SINGLETON(MetaBarViewController)

/**
 */
- (instancetype)initSingletone
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
- (IBAction)openMenuButton:(id)sender;
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

@end
