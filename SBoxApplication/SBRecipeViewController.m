//
//  SBRecipetViewController.m
//  SBoxApplication
//
//  Created by snowkrash on 02.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SBRecipeViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <UIImageView+AFNetworking.h>
#import "SBRecipeImageTableViewCell.h"
#import "SBRecipeIngredientTableViewCell.h"
#import "ApplicationManager.h"
#import "KADataModelRecipe.h"
#import "KADataModelIngredient.h"
#import "SlimboxServices.h"
#import "MetaBarViewController.h"


@interface SBRecipeViewController () 
@property (nonatomic, strong) NSMutableArray *tableViewModelArray;
@property (nonatomic, strong) KADataModelRecipe *recipe;
@property (nonatomic, strong) SBRecipeImageTableViewCell *recipeImageView;
@end

@implementation SBRecipeViewController 

- (void)initMetaBar
{
    // metabar setup
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [[MetaBarViewController instance]setTitle:@"Rezepte-Ansicht"];
    [[MetaBarViewController instance]showRightButtonLeft:false showRightButtonRight:true];
    [[[MetaBarViewController instance] setButtonForRightButtonRight:button] subscribeNext:^(id x) {
        NSLog(@"Pressed Close RecipeView");
        [[MetaBarViewController instance]popViewController];
    } ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ApplicationManager registerTableCell:@"SBRecipeImageTableViewCell" tableView:self.tableView cellResudeIndentifier:@"CellImageView"];
    [ApplicationManager registerTableCell:@"SBRecipeIngredientTableViewCell" tableView:self.tableView cellResudeIndentifier:@"CellIngredient"];
    self.recipeImageView = [self.tableView dequeueReusableCellWithIdentifier:@"CellImageView"];
    self.recipeImageView.titleImage.clipsToBounds = true;
    self.recipeImageView.titleImage.contentMode = UIViewContentModeScaleAspectFit;
        
    @weakify(self)
    
    // load all data from REST
    RACSignal *recipeSignal = [[SlimboxServices queryRecipeWithID:@"672"] flattenMap:^RACStream *(id value)
    {
        @strongify(self)
        self.recipe = value;
        return [SlimboxServices loadImageNamed:self.recipe.recipeImageURLBig forImageView:self.recipeImageView.titleImage placeholderImage:[UIImage imageNamed:@"#healthstream#star"]];
    }];
    
    // fill in datamodel and render tableview
    [recipeSignal subscribeNext:^(id x)
    {
        @strongify(self)
        [self.tableViewModelArray addObject:self.recipeImageView];
        for (KADataModelIngredient *ingredient in self.recipe.recipeDetails.recipeIngredients) {
            SBRecipeIngredientTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIngredient"];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumIntegerDigits:1];
            [formatter setMinimumFractionDigits:0];
            [formatter setGroupingSize:3];
            
            cell.amount.text = [NSString stringWithFormat:@"%@ %@",[formatter stringFromNumber:@(ingredient.ingredientQuantity)], (ingredient.ingredientQuantity>1)?ingredient.ingredientQuantityUnitPlural:ingredient.ingredientQuantityUnit];
            cell.ingredient.text = ingredient.ingredientName;
            [self.tableViewModelArray addObject:cell];
        }
        [self.tableView reloadData];
    }];
    
}

/**
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray*)tableViewModelArray
{
    if(!_tableViewModelArray)
    {
        return _tableViewModelArray = [NSMutableArray new];
    }
    return _tableViewModelArray;
}

/**
 Number of sections.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 Return heights for different cells.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if ([[self.tableViewModelArray objectAtIndex:row] isKindOfClass:[SBRecipeImageTableViewCell class]])
    {
        return[SBRecipeImageTableViewCell getHeight];
    }
    else if ([[self.tableViewModelArray objectAtIndex:row] isKindOfClass:[SBRecipeIngredientTableViewCell class]])
    {
        return[SBRecipeIngredientTableViewCell getHeight];
    }
    return 0;
}

/**
 Number of rows in sections.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewModelArray.count;
}

/**
 Render Healthstream-Cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (self.tableViewModelArray.count > 0)
    {
        return [self.tableViewModelArray objectAtIndex:row];
    }
    
    return [UITableViewCell new];
}

@end
