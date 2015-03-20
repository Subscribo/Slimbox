//
//  SlideShow.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SlideShow.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "SequencedAnimation.h"
#import "Animation.h" 
#import <POP.h>

@interface SlideShow ()
@property (nonatomic, strong) UIImageView *imageView01;
@property (nonatomic, strong) UIImageView *imageView02;
@property (nonatomic, strong) UIImage *image01;
@property (nonatomic, strong) UIImage *image02;
@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, strong) SequencedAnimation *animationSignal;
@property (nonatomic, strong) NSMutableArray *imageBuffer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) double indexState;
@property (nonatomic) int indexNames;
@property (nonatomic) int duration;
@property (nonatomic) BOOL toogleBuffer;
@end


@implementation SlideShow

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
    self.imageBuffer =[[NSMutableArray alloc]initWithObjects:[UIImage new], [UIImage new], nil];
    
    self.imageView01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView02 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [self addSubview:self.imageView01];
    [self addSubview:self.imageView02];

    self.imageView01.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView02.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imageView01.layer.opacity = 1;
    self.imageView02.layer.opacity = 0;
    
    self.imageView01.image = [UIImage imageNamed:[self.imageNames objectAtIndex:0]];
    self.indexNames=1;
    self.duration = 5;

    self.indexState = 0;
    self.toogleBuffer = true;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(validateState) userInfo:nil repeats:YES];
}

/*
 Simple timeline.
 */
- (void)validateState
{
    int state = (int)self.indexState;
    NSString *name;
    UIImage *nextImage;
    
    switch (state)
    {
        case 0:
            // Load image
            name = (NSString*)[self.imageNames objectAtIndex:self.indexNames];
            nextImage = [UIImage imageNamed:name];
            [self.imageBuffer replaceObjectAtIndex:(self.toogleBuffer?0:1) withObject:nextImage];
            self.toogleBuffer = !self.toogleBuffer;
            self.indexNames = (self.indexNames == self.imageNames.count-1)?0:++self.indexNames;
            break;
        case 02:
            // Fade image
            if (self.toogleBuffer)
            {
                UIImage *next = [self.imageBuffer objectAtIndex:((!self.toogleBuffer?0:1))];
                [self.imageView01 setImage:next];
                self.imageView01.transform = CGAffineTransformIdentity;
                [Animation fadeIn:self.imageView01 duration:self.duration completionBlock:^(POPAnimation *anim, BOOL finished){}];
                [Animation fadeOut:self.imageView02 duration:self.duration completionBlock:^(POPAnimation *anim, BOOL finished){}];
            }
            else
            {
                UIImage *next = [self.imageBuffer objectAtIndex:((!self.toogleBuffer?0:1))];
                [self.imageView02 setImage:next];
                self.imageView02.transform = CGAffineTransformIdentity;
                [Animation fadeIn:self.imageView02 duration:self.duration completionBlock:^(POPAnimation *anim, BOOL finished){}];
                [Animation fadeOut:self.imageView01 duration:self.duration completionBlock:^(POPAnimation *anim, BOOL finished){}];
            }
            break;
        case 3:
            // Zoom image
            [Animation zoom:((self.toogleBuffer)?self.imageView01:self.imageView02) duration:4 from:0 to:12];

            break;
        default:
            break;
    }
    
    //Wait and Replay
    self.indexState = ((self.indexState == 8) ? 0:++self.indexState);
}

@end

