//
//  SBHealthstreamCellBottomViewController.m
//  SBoxApplication
//
//  Created by snowkrash on 01.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SBHealthstreamCellBottomViewController.h"

@interface SBHealthstreamCellBottomViewController ()

@end

@implementation SBHealthstreamCellBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 Sets the controller type.
 */
- (void)setType:(SBHealthstreamCellBottomViewControllerType)type
{
    
}

#pragma mark - Actions 

/**
 */
- (IBAction)showDetail:(id)sender
{
    [self.delegate showDetail];
}

/**
 */
- (IBAction)shareOnFacebook:(id)sender
{
    [self.delegate shareFacebook];
}

/**
 */
- (IBAction)shareOnTwitter:(id)sender
{
    [self.delegate shareTwitter];
}

/**
 */
- (IBAction)shareOnEmail:(id)sender
{
    [self.delegate shareEmail];
}

@end
