//
//  SBRecipeIngredientTableViewCell.m
//  SBoxApplication
//
//  Created by snowkrash on 03.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SBRecipeIngredientTableViewCell.h"

@implementation SBRecipeIngredientTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight
{
    return 60;
}

@end
