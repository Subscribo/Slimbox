//
//  SBHealthStreamTableViewController.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 17.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaBarViewController.h"

@protocol SBHealthstreamCellBottomViewControllerDelegate <NSObject>
- (void)showDetail;
- (void)shareFacebook;
- (void)shareTwitter;
- (void)shareEmail;
@end

@interface SBHealthStreamTableViewController : UITableViewController <MetaBarDelegateController>
- (void)viewDidLoad;
- (void)loadNextForSignal;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)showDetail:(NSInteger)indexModel;
- (void)shareFacebook:(NSInteger)indexModel;
- (void)shareTwitter:(NSInteger)indexModel;
- (void)shareEmail:(NSInteger)indexModel;
@end
