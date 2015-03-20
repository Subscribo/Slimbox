//
//  SequencedAnimation.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SequencedAnimation.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "RALoadImage.h"
#import "RASignal.h"

/**
 #z#n: 
 + Adden von Animationen, FadeIn&Transpose, Zeit warten, nächste Animation 
 + Adden von einer Animation die eine Folge-Animation auslöst
 + Adden von einer Animation die erst nach X Sekunden startet. 
 
 
 zb. 
 + Fade Bild ein - Block m. Animation
 + Warte eine Zeit 
 + Fade-Aus 
 +
 
 
 
 
 */

@interface SequencedAnimation ()
@property (nonatomic, strong) RACSubject *signal;
@property (nonatomic, strong) RACSubject *signal1;
@property (nonatomic, strong) RACSubject *signal2;
@property (nonatomic, strong) RACSubject *signal3;

@property (nonatomic, strong) NSMutableArray *subscribers;
@property (nonatomic, strong) NSMutableArray *keyframes;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@property (nonatomic, strong) UIImageView *currentView;
@property (nonatomic, strong) UIImage *image01;
@property (nonatomic, strong) UIImage *image02;
@property (nonatomic) int x;

@property (nonatomic, strong) RACSubject *s1;
@property (nonatomic, strong) RACSubject *s2;
@property (nonatomic, strong) RACSubject *s3;
@property (nonatomic, strong) RACSubject *s4;

@property (nonatomic, strong) RACSignal *si1;
@property (nonatomic, strong) RACSignal *si2;
@property (nonatomic, strong) RACSignal *si3;
@property (nonatomic, strong) RACSignal *si4;

@end


@implementation SequencedAnimation

- (instancetype)init
{
    self = [super init];
    self.viewsWithName = [NSMutableDictionary new];
    return self;
}

- (void)blub
{
    NSLog(@"Blub");
}

- (void)test
{
    @weakify(self)

    self.s1 = [RACSubject subject];
    self.s2 = [[RACSubject subject]flattenMap:^RACStream*(id x){
        @strongify(self)
        return self.s1;
    }];
    self.s3 = [RACSubject subject];


//    
    [self.s1 subscribeNext:^(id x){
        NSLog(@"S1:Load:%@",x);
    }];
//    
    [self.s2 subscribeNext:^(id x){
        NSLog(@"S2:Fade:%@",x);
    }];
//
//    [self.s3 subscribeNext:^(id x){
//        NSLog(@"S3:Wait%@",x);
//    }];
//    
//
//    [self.s1 sendNext:@"Pic1"];
    [self.s2 sendNext:@"View"];
    
    
    
//    self.si1 = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
//        @strongify(self)
//        [subscriber sendNext:@"Si1 to Subscriber"];
//    }];
//    
//    self.si2 = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
//        @strongify(self)
//        [subscriber sendNext:@"Si2 to Subscriber"];
//    }];
//
//    RACSequence *sq1 = @[self.si1,self.si2].rac_sequence;
//    
//    [sq1.signal subscribeNext:^(id x){
//        //
//    }];
//    
    
    

//    RACScheduler *scheduler = [[RACTargetQueueScheduler alloc] initWithName:@"testScheduler" targetQueue:dispatch_get_main_queue()];
//    [scheduler schedule:^{
//        @strongify(self)
//    }];
//    
//    
//    [self.s1 subscribeNext:^(NSString *x)
//     {
//         @strongify(self)
//         NSLog(@"Subscriber A:%@",self.x);
//     }];
//
//    
//    [self.s1 sendNext:@"test"];
//
    
    
    
    
//    //self.signal = [[RASignal subject];
//                   
//                   
//    RACSubject *s1 = [RACSubject subject];
//
//    
//    dispatch_queue_t global_default_queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    RACScheduler *scheduler = [[RACTargetQueueScheduler alloc] initWithName:@"testScheduler" targetQueue:dispatch_get_main_queue()];
//    [scheduler schedule:^{
//        @strongify(self)
//        self.signal = [[RACSubject subject] setNameWithFormat:@"subject1"];
//        RACSubject *subject2 = [[RACSubject subject] setNameWithFormat:@"subject2"];
//        
//        [subject1 subscribeNext:^(id x)
//         {
//             @strongify(self)
//             NSLog(@"Subscriber A:%i",self.x);
//         }];
//        
//        [subject1 sendNext:@(1)];
//    }];
//    
    
    
}
    
    
    
//    RACSignal *s2 = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
//        @strongify(self)
//        NSLog(@"s2");
//        [NSThread sleepForTimeInterval:5000];
//        [subscriber sendNext:nil];
//    }];
//
//    RACSignal *s3 = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
//        @strongify(self)
//        NSLog(@"1");
//        [NSThread sleepForTimeInterval:5000];
//        [subscriber sendNext:nil];
//    }];
//    
//    RACSignal *s4 = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
//        @strongify(self)
//        NSLog(@"s4");
//        [NSThread sleepForTimeInterval:5000];
//        [subscriber sendCompleted];
//    }] then:^RACSignal*{
//        return s2;
//    }];
//    
//    [s4 subscribeNext:^(id x) {
//        NSLog(@"SubS4");
//    }];
//}
    
//                     
//                     then:^RACDisposable*{
//        return [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
//            @strongify(self)
//            NSLog(@"2");
//            [NSThread sleepForTimeInterval:5000];
//            [subscriber sendNext:nil];}];
    
    
    
                   
//    self.signal1 = [RASignal subject];
                   
                   
                   
                   
//    
//    self.signal.name = @"S1";
//    self.signal1.name = @"S2";
//    
//    self.currentView = [self.viewsWithName objectForKey:@"test"];
//    
//    RACSequence *seq =  @[self.signal, self.signal1].rac_sequence;
//    
//    //Load
//    [self.signal subscribeNext:^(id x){
//        @strongify(self)
//        self.image01 = [UIImage imageNamed:@"#log#pic#01.png"];
//    }];
//
//    //Fade
//    [self.signal1 subscribeNext:^(id x){
//        @strongify(self)
//        self.currentView.layer.opacity = 0;
//        [UIView animateWithDuration:7 animations:^{
//            self.currentView.image = self.image01;
//            self.currentView.layer.opacity = 1;
//        }];
//    }];
//    
//    [seq.signal subscribeNext:^(id x){
//        NSLog(@"Subscribefrom sequence %@", x);
//        [x sendNext:nil];
//    }];
//  
//    
//    
//    
//    
////    
////    RASignal *testSignal = [[RASignal createSignal:^RACDisposable*(id<RACSubscriber>didSubscribe){
////        //
////    }]then:^RACSignal{
////        //Load Image
////        return [RALoadImage initWithName:@"#log#pic#01"];
////    }]then:^RACSignal{
////        //Fade In
////        return [RAFade initWithOption:RAChange];
////    }]
////    ;
//    
//    
//    self.subscribers = [NSMutableArray new];
//    self.keyframes = [NSMutableArray new];
////    self.signal = [RACSignal  createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
////        @strongify(self)
////        [self.subscribers addObject:subscriber];
////        self.subscriber = subscriber;
////        NSLog(@"Im Sequenzer Added");
////    }];
//    
//    
//    
//    
//    





- (void)addSubscriber:(void(^)(id))next
{
    [self.signal subscribeNext:next];
    [self.keyframes addObject:@0];
}

- (void)addSubscriber:(void(^)(id))next delay:(NSTimeInterval)delay
{
    [self.signal subscribeNext:next];
   // [self.signal ]
}


//- (void) addAnimation:Block scheduledAt:Time
//{
//    
//}



- (void)sendSignal
{
    for (id<RACSubscriber>sub in self.subscribers)
    {
        RACScheduler *sc = [RACScheduler  mainThreadScheduler];
        [sc afterDelay:5 schedule:^{[sub sendNext:nil];}];
//        [sc schedule:^{
//            [sub sendNext:nil];
//        }];
//        [sub sendNext:nil];
    }
}


@end
