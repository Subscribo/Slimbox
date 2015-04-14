//
//  SBCameraController
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//


#import "SBPhotoViewController.h"
#import "ViewUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "ApplicationManager.h"

@interface SBPhotoViewController ()
@property (strong, nonatomic) SBCameraController *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (nonatomic,strong) IBOutlet UIButton *makePhoto;
@property (nonatomic,strong) IBOutlet UIButton *flashButton;
@property (nonatomic,strong) IBOutlet UIView *cameraView;
@end

@implementation SBPhotoViewController

- (void)initMetaBar
{
    
}

/**
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.camera = [[SBCameraController alloc] initWithQuality:CameraQualityPhoto andPosition:CameraPositionBack];
    self.camera.fixOrientationAfterCapture = NO;
    [self.cameraView addSubview:self.camera.view];
    
    // take the required actions on a device change
    @weakify (self)
    [self.camera setOnDeviceChange:^(SBCameraController *camera, AVCaptureDevice * device)
    {
        @strongify(self)
        if([camera isFlashAvailable])
        {
            self.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff)
            {
                self.flashButton.selected = NO;
            }
            else
            {
                self.flashButton.selected = YES;
            }
        }
        else
        {
            self.flashButton.hidden = YES;
        }
    }];
    
    // set Camera-Access Rights
    [self.camera setOnError:^(SBCameraController *camera, NSError *error)
    {
        @strongify(self)
        if([error.domain isEqualToString:SBCameraErrorDomain]) {
            if(error.code == SBCameraErrorCodePermission) {
                if(self.errorLabel)
                    [self.errorLabel removeFromSuperview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = [ApplicationManager translate:@"Camera-Rechte"];
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                self.errorLabel = label;
                [self.view addSubview:self.errorLabel];
            }
        }
    }];
}

/**
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.camera start];
}

/**
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.camera stop];
}

#pragma mark - Camera 

/**
 */
- (IBAction)flashButtonPressed:(id)sender
{
    if(self.camera.flash == CameraFlashOff)
    {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        
        if(done)
        {
            self.flashButton.selected = YES;
        }
    }
    else
    {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done)
        {
            self.flashButton.selected = NO;
        }
    }
}

- (IBAction)takePhoto:(id)sender
{
    @weakify(self);
    [self.camera capture:^(SBCameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error)
    {
        @strongify(self)
        if(!error)
        {
            [camera stop];
            self.takenPhoto = image;
            [self.delegate showFinishDataDialog];
        }
        else
        {
            //
        }
    } exactSeenImage:YES];
    
}

/**
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


/**
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
