//
//  SBHealthStreamTableViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 17.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SBHealthStreamTableViewController.h"
#import "ApplicationManager.h"
#import "Animation.h"
#import "PHealthstreamEventNutrition.h"
#import "PHealthstreamEvent.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "SBHealthstreamCellBottomViewController.h"
#import "PHealthstreamEventNutrition.h"
#import "NutritionTableViewCell.h"
#import "SBRecipeViewController.h"
#import "KARecipeManager.h"

@interface SBHealthStreamTableViewController ()
@property (nonatomic, strong) NSMutableArray *hsEvents;
@property (nonatomic, strong) SBRecipeViewController *recipeController;
@end

@implementation SBHealthStreamTableViewController

/**
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ApplicationManager instance] unhideMetaMenuBar];
    [ApplicationManager registerTableCell:@"NutritionTableViewCell" tableView:self.tableView cellResudeIndentifier:@"Nutrition"];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.opacity = 0;
    [Animation fadeIn:self.view duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    //[[ApplicationManager model]setupMockupDataForUser]; // Create data for testing purposes
    [self loadNextForSignal];
}


/**
 Load N-Entries for the table.
 */
- (void)loadNextForSignal
{
    @weakify(self)
    RACSubject *loadItems = [RACSubject subject];
    [loadItems subscribeNext:^(id items)
    {
        @strongify(self)
        self.hsEvents = (NSMutableArray*)items;
        [self.tableView reloadData];
    }];
    [[ApplicationManager model] loadNext:loadItems option:kSBEventsLoadInitital];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    if (self.hsEvents && self.hsEvents.count > row)
    {
        if ([[self.hsEvents objectAtIndex:row] isKindOfClass:[PHealthstreamEventNutrition class]])
        {
            return [NutritionTableViewCell getHeight];
        }
    }
    return 0;
}

/**
 Lazy Loading Entries.
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // load future events
    if (scrollView.contentOffset.y < 0)
    {
        //
    }
    
    // load past events
    if (scrollView.contentOffset.y > scrollView.contentSize.height*0.8)
    {
        //
    }

}

/**
 Number of rows in sections.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hsEvents.count;
}

/**
 Render Healthstream-Cells. 
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NutritionTableViewCell *cell = (NutritionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Nutrition" forIndexPath:indexPath];
    int row = indexPath.row;
    
    if (self.hsEvents && self.hsEvents.count > row)
    {
        PFObject *rowObject = (PFObject*)[self.hsEvents objectAtIndex:row];
        
        // Setup Nutrition Events
        if ([rowObject isKindOfClass:[PHealthstreamEventNutrition class]])
        {
            PHealthstreamEventNutrition *nutrition = (PHealthstreamEventNutrition*)rowObject;
            [cell initButtonController:cell];
            [cell setTimestamp:nutrition.timestamp];
            [cell setReceiptImageView:[UIImage imageWithData:[nutrition.image getData]]];
            [cell setTitleText:nutrition.title];
            [cell setCaloriesValue:nutrition.calories];
            [cell setRating:nutrition.rating];
            cell.indexDataModel = row;
            cell.delegate = self;
        }
        
        // Setup Consulter Message Entries
        
        
        // Setup Healthcare-Assistant Entries
    }
    
    return cell;
}

/**
 Show Receipt Details.
 */
- (void)showDetail:(NSInteger)indexModel
{
    self.recipeController = [[SBRecipeViewController alloc] initWithNibName:@"SBRecipeViewController" bundle:nil];

    [self presentViewController:self.recipeController animated:YES completion:^{}];
}

/**
 */
- (void)shareFacebook:(NSInteger)indexModel
{
    
}

/**
 */
- (void)shareTwitter:(NSInteger)indexModel
{
    
}

/**
 */
- (void)shareEmail:(NSInteger)indexModel
{
    
}

@end
