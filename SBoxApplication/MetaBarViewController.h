//
//  MetaBarViewController.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 11.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
@interface MetaBarViewController : UIViewController
SingletonInit
- (float)getHeight;
- (IBAction)openMenuButton:(id)sender;


@end
