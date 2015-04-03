//
//  MetaMenuTableCell.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetaMenuTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIView *background;
@property (nonatomic, strong) IBOutlet UIImageView *icon;

- (float)getHeight;

@end
