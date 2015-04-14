//
//  SBRecipeImageTableViewCell.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 03.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBRecipeImageTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *titleImage;

+ (CGFloat)getHeight;
@end
