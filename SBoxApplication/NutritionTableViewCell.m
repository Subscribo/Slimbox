//
//  NutritionTableViewCell.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 01.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "NutritionTableViewCell.h"
#import "ApplicationManager.h"
#import "SBHealthstreamCellBottomViewController.h"
#import "SBRecipeViewController.h"
#import "ApplicationManager.h"

@interface NutritionTableViewCell ()
@property (nonatomic, strong) SBHealthstreamCellBottomViewController *bottomViewController;
@end

@implementation NutritionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 */
- (void)initButtonController:(id)delegate
{
    self.bottomViewController = [[SBHealthstreamCellBottomViewController alloc] initWithNibName:@"SBHealthstreamCellBottomViewController" bundle:nil];
    self.bottomViewController.view.frame = CGRectMake(self.bottomViewController.view.frame.origin.x, self.backgroundCellView.frame.size.height, self.bottomViewController.view.frame.size.width,self.bottomViewController.view.frame.size.height);
    [self.bottomViewController setType:SBHealthstreamCellBottomViewControllerTypeSharingDetail];
    [self addSubview:self.bottomViewController.view];
    self.bottomViewController.delegate = delegate;
}

/**
 */
+ (int)getHeight
{
    return 250;
}

/**
 */
- (void)setTimestamp:(NSDate*)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd.mm.yyyy"];
    self.date.text =  [formatter stringFromDate:date];

}

/**
 */
- (void)setReceiptImageView:(UIImage*)recipeImage
{
    self.recipeImage.image = recipeImage;
    self.recipeImage.clipsToBounds = true;
    self.recipeImage.contentMode = UIViewContentModeScaleAspectFill;
}

/**
 */
- (void)setTitleText:(NSString*)text
{
    self.title.text = text;
    [self.title sizeToFit];
}

/**
 */
- (void)setRating:(NSNumber*)rating
{
    int stars = [rating intValue];
    for (int i = 0; i < stars; i++)
    {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"#healthstream#star"]];
        CGRect starFrame = CGRectMake(self.ratingStar.frame.origin.x-(self.ratingStar.frame.size.width*i), self.ratingStar.frame.origin.y, self.ratingStar.frame.size.width, self.ratingStar.frame.size.height);
        starImageView.frame = starFrame;
        [self addSubview:starImageView];
    }
}

/**
 */
- (void)setCaloriesValue:(NSNumber*)calories
{
    self.calories.text = [NSString stringWithFormat:@"%d kcal", [calories intValue]];
}


- (void)showDetail
{
    [self.delegate showDetail:self.indexDataModel];
}

/**
 */
- (void)shareFacebook
{
    [self.delegate shareFacebook:self.indexDataModel];
}

/**
 */
- (void)shareTwitter
{
    [self.delegate shareTwitter:self.indexDataModel];
}

/**
 */
- (void)shareEmail
{
    [self.delegate shareEmail:self.indexDataModel];
}

@end
