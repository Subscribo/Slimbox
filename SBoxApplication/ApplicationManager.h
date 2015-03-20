/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SBApplicationModel.h"
#import "Singletone.h"
#import "ResourceManager.h"

/**
 Application-Manager
 */
@interface ApplicationManager : UIViewController <UIAlertViewDelegate>
SINGLETONE

- (id)initSingletone;
- (void)setupNotifications;
- (void)addMetaMenuBar;
- (void)hideMetaMenuBar;
- (void)unhideMetaMenuBar;
- (float)heightMetaMenuBar;
- (void)openMetaMenu;
- (void)setupOffscreenCanvas;
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
@end
