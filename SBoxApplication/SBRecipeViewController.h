//
//  SBRecipetViewController.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 02.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KARecipeManager.h"
#import "MetaBarViewController.h"

@interface SBRecipeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MetaBarDelegateController>
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
