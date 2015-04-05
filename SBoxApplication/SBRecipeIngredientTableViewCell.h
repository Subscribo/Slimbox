//
//  SBRecipeIngredientTableViewCell.h
//  SBoxApplication
//
//  Created by snowkrash on 03.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBRecipeIngredientTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *icon;
@property (nonatomic, strong) IBOutlet UILabel *ingredient;
@property (nonatomic, strong) IBOutlet UILabel *amount;

+ (CGFloat)getHeight;
@end
