/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SBApplicationModel.h"
#import "Singleton.h"
#import "ResourceManager.h"

#define SIGNF(x) (x >= 0.0f) ? 1.0f : -1.0f;
#define objectIsNil(obj) (!obj || obj == (id)[NSNull null])

#ifndef SYSTEM_VERSION_LESS_THAN
#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedAscending)
#endif

/**
 Application-Manager
 */
@interface ApplicationManager : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) UIView *applicationView;


SingletonInit
- (void)setupNotifications;
- (void)addMetaMenuBar;
- (void)hideMetaMenuBar;
- (void)unhideMetaMenuBar;
- (float)heightMetaMenuBar;
- (void)openMetaMenu;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (BOOL)prefersStatusBarHidden;
- (void)applicationViewAddView:(UIView*)view;
- (void)frameworkViewAddView:(UIView*)view;
- (void)applicationViewRemoveAllViews;
- (void)frameworkViewRemoveAllViews;
+ (SBApplicationModel*) model;
- (ResourceManager*)resources;
- (void)execute:(NSString*)name;
-  (void)setControllerWithName:(NSString*)nameNIB;
- (void)show;
+ (CGRect) getApplicationFrame;
+ (CGRect)getApplicationBounds;
+ (CGRect)getScreenFrame;
+ (int)getScreenHeight;
+ (int)getScreenWidth;
- (CGRect)getApplicationViewFrame;
+ (NSString *)getApplicationVersion;
+ (NSString *)getApplicationName;
+ (UINib*)getNib:(NSString*)name;
+ (void)getNib:(NSString*)name owner:(id)owner;
+ (void) registerTableCell:(NSString*)name tableView:(UITableView*)tableView cellResudeIndentifier:(NSString*)identifier;
+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;
+ (UIColor *)colorWithHexString:(NSString *)str;
- (void)systemError:(NSString*)errorStringTag error:(NSError*)error option:(NSNumber*)option completionBlock:(void(^)())completionBlock;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
+ (NSString*)translate:(NSString*)text;
+ (NSDate*)stringToDate:(NSString*)dateString;
+ (NSString*)dateToString:(NSDate*)date;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (NSInteger)randomIntBetween:(NSInteger)min and:(NSInteger)max;
- (void)showHUD:(BOOL)show;
+ (NSString*)dateToString:(NSDate*)date formater:(NSDateFormatter*)formatter;
- (void)applicationViewFullscreen;
- (void)applicationFrameWindowed;
- (CGRect)getApplicationViewBounds;
@end
