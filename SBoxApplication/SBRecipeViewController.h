//
//  SBRecipetViewController.h
//  SBoxApplication
//
//  Created by snowkrash on 02.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KARecipeManager.h"

@interface SBRecipeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
