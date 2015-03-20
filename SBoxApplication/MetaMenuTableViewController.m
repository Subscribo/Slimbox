//
//  MetaMenuTableViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "MetaMenuTableViewController.h"
#import "ApplicationManager.h"
#import "Animation.h"
#import "MetaMenuTableViewCell.h"

@interface MetaMenuTableViewController ()
@property (nonatomic) int colorIndex;
@property (nonatomic, strong) NSMutableArray *execute;
@property (nonatomic, strong) NSMutableArray *cellTitles;
@property (nonatomic, strong) NSMutableArray *cellColors;
@property (nonatomic, strong) NSMutableArray *icons;
@property (nonatomic) float fixedRowHeight;

@end

@implementation MetaMenuTableViewController

/**
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    static int colorIndex = 0;
    
    // Load configuration from plist
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"configuration" ofType:@"plist"]];
    NSArray *array = dict[@"MetaMenuItems"];
    self.execute = [NSMutableArray new];
    self.cellTitles = [NSMutableArray new];
    self.cellColors = [NSMutableArray new];
    self.icons = [NSMutableArray new];
    
    for (NSDictionary *itemDict in array)
    {
        [self.execute addObject:itemDict[@"Execute"]];
        [self.cellTitles addObject:itemDict[@"Title"]];
        [self.cellColors addObject:itemDict[@"Color"]];
        // #t: load and insert icon
    }
    
    [self loadData];
    [ApplicationManager registerTableCell:@"MetaMenuTableViewCell" tableView:self.tableView cellResudeIndentifier:@"MetaMenuItem"];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

/**
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 */
- (void)loadData
{
}

#pragma mark - Table view data source

/**
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

/**
 Return cell.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MetaMenuTableViewCell *cell = (MetaMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MetaMenuItem" forIndexPath:indexPath];
    int row = (int)indexPath.row;
    int count = (int)self.cellColors.count;
    int modulo= (row%count);

    NSString *cellColor = [self.cellColors objectAtIndex:modulo];
    NSString *cellTitle = [self.cellTitles objectAtIndex:modulo];
    cell.background.backgroundColor = [ApplicationManager colorWithHexString:cellColor];
    cell.name.text = cellTitle;
    self.fixedRowHeight = cell.frame.size.height;
    // #t: insert icon

    return cell;
}

/**
 Animate (Rotation, Fade) Cell while showing up.
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    float animationConstraint = ([ApplicationManager getScreenHeight]/self.fixedRowHeight)+1;
    
    if (indexPath.row > animationConstraint || tableView.contentOffset.y > 0)
    {
        return;
    }

    /* Manual Animation #b: Migrate to Animation-Lib */
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0, 1);
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0);
    
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    [UIView beginAnimations:@"rotation" context:NULL];
    if (indexPath.row < 10 && tableView.contentOffset.y < 20)
    {
        [UIView setAnimationDelay:indexPath.row*0.10];
    }
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

#pragma mark - Table view delegate

/**
 Execute Application Controller.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *executeTitle = self.execute[(indexPath.row % self.execute.count)];
    [[ApplicationManager instance] openMetaMenu];
    [[ApplicationManager instance] execute:executeTitle];
}

@end
