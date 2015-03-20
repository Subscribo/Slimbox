//
//  RAFade.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 26.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "RASignal.h"

typedef enum {
    FAFadeIn,
    FAFadeOut,
    FAFadeChange
} FAFade;

@interface RAFade : RASignal

@end
