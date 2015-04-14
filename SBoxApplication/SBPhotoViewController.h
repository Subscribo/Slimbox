//
//  SBCameraController
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SBCameraController.h"
#import "MetaBarViewController.h"
#import "SBRecipePhotoViewController.h"

@interface SBPhotoViewController : UIViewController <MetaBarDelegateController>
@property (nonatomic,weak)  SBRecipePhotoViewController  *delegate;
@property (nonatomic,strong)  UIImage  *takenPhoto;
@end
