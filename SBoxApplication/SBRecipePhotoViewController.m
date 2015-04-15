//
//  SBRecipePhotoViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 11.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SBRecipePhotoViewController.h"
#import "SBCameraController.h"
#import "SBPhotoViewController.h"

@interface SBRecipePhotoViewController ()
@property (nonatomic, strong) SBPhotoViewController *photoViewController;
@property (nonatomic, strong) IBOutlet UIView *descriptionView;
@property (nonatomic, strong) IBOutlet UIView *dataView;
@property (nonatomic, strong) IBOutlet UIButton *pictureButton;
@property (nonatomic, strong) IBOutlet UIButton *finishButton;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, strong) IBOutlet UIImageView *picture;
@end

@implementation SBRecipePhotoViewController

/**
 */
- (void)initMetaBar
{
    // setup quitbutton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [[MetaBarViewController instance]setTitle:@"Fotobericht"];
    [[MetaBarViewController instance]showRightButtonLeft:false showRightButtonRight:true];
    [[[MetaBarViewController instance] setButtonForRightButtonRight:button] subscribeNext:^(id x)
    {
        [[MetaBarViewController instance]popViewController];
    }];
}

/**
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showDescriptionDialog];
}

/**
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 */
- (void)showDescriptionDialog
{
    [self.view addSubview:self.descriptionView];
}

/**
 */
- (void)showCameraDialog
{
    self.photoViewController = [[SBPhotoViewController alloc] initWithNibName:@"SBPhotoViewController" bundle:nil];
    self.photoViewController.delegate = self;
    [[MetaBarViewController instance] pushViewController:self.photoViewController];
}

/**
 */
- (void)showFinishDataDialog
{
    [self.picture setImage:self.photoViewController.takenPhoto];
    [[MetaBarViewController instance] popViewController];
    [self.view addSubview:self.dataView];
}

/**
 */
- (void)createAndStoreEventToParse
{
    
}

/**
 */
- (IBAction)makeNewPicture:(id)sender
{
    [self showCameraDialog];
}

#pragma mark - Actions

/**
 */
- (IBAction)proceedToCamera:(id)sender
{
    [self.descriptionView removeFromSuperview];
    [self showCameraDialog];
}

/**
 */
- (IBAction)takePhoto:(id)sender
{
}

/**
 */
- (IBAction)finish:(id)sender
{
}
@end
