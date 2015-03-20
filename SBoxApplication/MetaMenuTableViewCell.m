//
//  MetaMenuTableCell.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "MetaMenuTableViewCell.h"
#import "ApplicationManager.h"

@implementation MetaMenuTableViewCell

/**
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}

/**
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Init here.
    }
    return self;
}


- (instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}


- (float)getHeight
{
    return self.contentView.frame.size.height;
}


@end
