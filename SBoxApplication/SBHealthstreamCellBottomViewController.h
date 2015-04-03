//
//  SBHealthstreamCellBottomViewController.h
//  SBoxApplication
//
//  Created by snowkrash on 01.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBHealthStreamTableViewController.h"
typedef enum
{
 SBHealthstreamCellBottomViewControllerTypeSharingDetail,
 SBHealthstreamCellBottomViewControllerTypeDetail
} SBHealthstreamCellBottomViewControllerType;

@interface SBHealthstreamCellBottomViewController : UIViewController
@property (nonatomic, weak) id<SBHealthstreamCellBottomViewControllerDelegate> delegate;

- (void)setType:(SBHealthstreamCellBottomViewControllerType)type;

- (IBAction)showDetail:(id)sender;
- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;
- (IBAction)shareOnEmail:(id)sender;



@end
