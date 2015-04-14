//
//  SBCameraController
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger
{
    CameraPositionBack,
    CameraPositionFront
} CameraPosition;

typedef enum : NSUInteger
{
    CameraFlashOff,
    CameraFlashOn,
    CameraFlashAuto
} CameraFlash;

typedef enum : NSUInteger
{
    CameraQualityLow,
    CameraQualityMedium,
    CameraQualityHigh,
    CameraQualityPhoto
} CameraQuality;

extern NSString *const SBCameraErrorDomain;
typedef enum : NSUInteger {
    SBCameraErrorCodePermission = 10,
    SBCameraErrorCodeSession = 11
} SBCameraErrorCode;

@interface SBCameraController : UIViewController

@property (nonatomic, copy) void (^onDeviceChange)(SBCameraController *camera, AVCaptureDevice *device);
@property (nonatomic, copy) void (^onError)(SBCameraController *camera, NSError *error);
@property (nonatomic, readonly) CameraFlash flash;
@property (nonatomic) CameraPosition position;
@property (nonatomic) BOOL fixOrientationAfterCapture;
@property (nonatomic) BOOL tapToFocus;
@property (nonatomic) BOOL useDeviceOrientation;
- (instancetype)initWithQuality:(CameraQuality)quality andPosition:(CameraPosition)position;
- (void)start;
- (void)stop;
- (void)attachToViewController:(UIViewController *)vc withFrame:(CGRect)frame;
- (CameraPosition)togglePosition;
- (BOOL)updateFlashMode:(CameraFlash)cameraFlash;
- (void)alterFocusBox:(CALayer *)layer animation:(CAAnimation *)animation;
-(void)capture:(void (^)(SBCameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture exactSeenImage:(BOOL)exactSeenImage;
-(void)capture:(void (^)(SBCameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture;
- (BOOL)isFlashAvailable;
@end
