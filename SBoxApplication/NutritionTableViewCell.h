//
//  NutritionTableViewCell.h
//  SBoxApplication
//
//  Created by snowkrash on 01.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBHealthStreamTableViewController.h"

@interface NutritionTableViewCell : UITableViewCell <SBHealthstreamCellBottomViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *calories;
@property (nonatomic, strong) IBOutlet UIView *buttonView;
@property (nonatomic, strong) IBOutlet UIImageView *ratingStar;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UIImageView *recipeImage;
@property (nonatomic, strong) IBOutlet UIView *backgroundCellView;
@property (nonatomic) int indexDataModel;

@property (nonatomic, weak) SBHealthStreamTableViewController *delegate;

- (void)setTimestamp:(NSDate*)date;
- (void)setReceiptImageView:(UIImage*)recipeImage;
- (void)setTitleText:(NSString*)text;
- (void)setRating:(NSNumber*)rating;
- (void)setCaloriesValue:(NSNumber*)calories;
- (void)initButtonController:(id)delegate;
+ (int)getHeight;

- (void)showDetail;
- (void)shareFacebook;
- (void)shareTwitter;
- (void)shareEmail;

@end
