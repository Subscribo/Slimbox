//
//  ScrollerMovingText.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 01.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//


#import "ScrollerMovingText.h"
#import "Animation.h"


@interface ScrollerMovingText ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) double indexState;
@property (nonatomic) int indexNames;
@property (nonatomic) BOOL toogleBuffer;
@property (nonatomic) NSString *currentText;
@end

@implementation ScrollerMovingText

/**
 + Erstelle den Label und setze den Font usw.
 + Plazieren
 + Bewegen, Warten, rausbewegen replay
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void)start
{
    self.backgroundColor = [UIColor clearColor];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    self.label.layer.opacity = 1;
    self.label.layer.anchorPoint = CGPointZero;
    self.label.layer.position = CGPointZero;
    self.label.layer.opacity = 0;
    [self.label sizeToFit];
    
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:30];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];

    [self addSubview:self.label];
    self.indexNames=0;
    self.duration = 5;
    self.indexState = 0;
    self.toogleBuffer = true;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(validateState) userInfo:nil repeats:YES];
}


- (void)setFont:(UIFont*)font color:(UIColor*)color
{
    self.label.font = font;
    self.label.textColor = color;
}

/*
 Simple timeline.
 */
- (void)validateState
{
    int state = (int)self.indexState;
    switch (state)
    {
        case 0:
            // Load Text & Move-Out
            self.label.text = [self.strings objectAtIndex:self.indexNames];
            self.indexNames = (self.indexNames == self.strings.count-1) ? 0 : ++self.indexNames;
            self.label.layer.opacity = 1;
            [self.label sizeToFit];
            //CGFloat y = (self.frame.size.height/2-(self.label.frame.size.height/2));
            CGFloat x = (self.frame.size.width/2-(self.label.frame.size.width/2));
//            self.label.frame = CGRectMake(0,y, self.label.frame.size.width, self.label.frame.size.height);

            
            [Animation moveX:self.label duration:self.duration from:1200 to:x delegate:self animationID:@""];
            break;
        case 15:
            [Animation moveX:self.label duration:self.duration from:self.label.frame.origin.x to:-1200 delegate:self animationID:@""];
            break;
        default:
            break;
    }
    
    //Wait and Replay
    self.indexState = ((self.indexState == 17) ? 0:++self.indexState);
}

@end
