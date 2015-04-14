//
//  SBRecipePhotoViewController.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 11.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaBarViewController.h"

@interface SBRecipePhotoViewController : UIViewController <MetaBarDelegateController>
- (void)initMetaBar;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)showDescriptionDialog;
- (void)showCameraDialog;
- (void)showFinishDataDialog;
- (void)createAndStoreEventToParse;
- (IBAction)proceedToCamera:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)finish:(id)sender;
@end
