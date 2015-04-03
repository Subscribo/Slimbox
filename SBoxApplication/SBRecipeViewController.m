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

@interface SBRecipeViewController ()

@end

@implementation SBRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Test
    @weakify(self)
    [[KARecipeManager sharedRecipeManager] getRecipeWithID:@"671" andCompletitionBlock:^(KADataModelRecipe *recipe)
     {
         @strongify(self)
         self.name.text = recipe.recipeName;
         [self.imageView setImageWithURL:[NSURL URLWithString:recipe.recipeImageURLBig]];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
