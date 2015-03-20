//
//  SlideShow.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideShow : UIView

@property (nonatomic, strong) NSArray *imageNames;

- (void)start;
@end
