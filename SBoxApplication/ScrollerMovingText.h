//
//  ScrollerMovingText.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 01.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollerMovingText : UIView
@property (nonatomic, strong)NSMutableArray *strings;
@property (nonatomic) int duration;
- (void)start;
- (void)setFont:(UIFont*)font color:(UIColor*)color;

@end
