/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#import "ApplicationManager.h"
#import "Singletone.h"
#import "AppDelegate.h"
#import "SBApplicationModel.h"
#import "ResourceManager.h"
#import "MetaBarViewController.h"
#import "MetaMenuTableViewController.h"
//Controller
#import "SBDebugViewController.h"
#import "SBNotifications.h"
#import "SBHealthStreamTableViewController.h"
#import "SBLoginViewController.h"
#import "Animation.h"

/**
 */
@interface ApplicationManager ()
@property (nonatomic, strong) UIWindow *parentWindow;
@property (nonatomic, strong) UIView *offscreenCanvasView;
@property (nonatomic, strong) UIViewController *offscreenCanvasViewController;
@property (nonatomic, strong) UIView *applicationView;
@property (nonatomic, strong) UIView *frameworkView;
@property (nonatomic, strong) UIViewController *activeController;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UISwipeGestureRecognizer *gestureSwipeRight;
@property (nonatomic, strong) UISwipeGestureRecognizer *gestureSwipeLeft;
@property (nonatomic) BOOL isMetaMenuOpen;
@property (nonatomic) MetaBarViewController *metaBarViewController;
@property (nonatomic) MetaMenuTableViewController *metaMenuTableViewController;

@end

@implementation ApplicationManager
SINGLETON(ApplicationManager)

/**
 Init ApplicationManager implementation.
 */
- (id)initSingletone
{
    if ((self = [super init]))
    {
        // Setup Windowxxx
        self.parentWindow = [[UIWindow alloc] initWithFrame:[ApplicationManager getApplicationBounds]];

        // Setup Manager
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        self.view = [[UIView alloc] initWithFrame:[ApplicationManager getApplicationBounds]];
        self.offscreenCanvasView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ApplicationManager getScreenWidth], 40)];
        self.applicationView = [[UIView alloc] initWithFrame:[ApplicationManager getApplicationBounds]];
        self.frameworkView = [[UIView alloc] initWithFrame:[ApplicationManager getApplicationBounds]];
        self.frameworkView.hidden = true;
        //  self.frameworkView.userInteractionEnabled = false;
        self.applicationView.backgroundColor = [UIColor clearColor];

        [self.view addSubview:self.applicationView];
        [self.view addSubview:self.offscreenCanvasView];
        [self.view addSubview:self.frameworkView];
        
        self.parentWindow.rootViewController = self;
        [self.parentWindow makeKeyAndVisible];
        
        // MetaMenu
        [self addMetaMenuBar];
        [self hideMetaMenuBar];
        [self setupNotifications];
        
		// Setup ResourceManager
		//[self getResourceManager];
        return self;
    }
    return self;
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMetaMenu) name:NotifyOpenMetaMenu object:nil];
}

#pragma mark - MenuBar and MetaMenu

/**
 Add MetaBar to the views.
 */
- (void)addMetaMenuBar
{
    
    [self.offscreenCanvasView addSubview:self.metaBarViewController.view];

}

- (void)hideMetaMenuBar
{
    self.metaBarViewController.view.hidden = true;
}

- (void)unhideMetaMenuBar
{
    self.metaBarViewController.view.hidden = false;
    self.metaBarViewController.view.layer.opacity = 0;
    [Animation fadeIn:self.metaBarViewController.view duration:3 completionBlock:nil];
}



- (MetaBarViewController*)metaBarViewController
{
    if (!_metaBarViewController)
    {
        _metaBarViewController = [[MetaBarViewController alloc] initWithNibName:@"MetaBarViewController"  bundle:nil];

    }
    return _metaBarViewController;
}

- (MetaMenuTableViewController*)metaMenuTableViewController
{
    if (!_metaMenuTableViewController)
    {
        _metaMenuTableViewController = [[MetaMenuTableViewController alloc] initWithNibName:@"MetaMenuTableViewController"  bundle:nil];
        
    }
    return _metaMenuTableViewController;
}


- (float)heightMetaMenuBar
{
    return [self.metaBarViewController getHeight];
}



- (void)openMetaMenu
{
    if (!self.isMetaMenuOpen)
    {
        self.frameworkView.hidden = false;
        [self.frameworkView addSubview:self.metaMenuTableViewController.view];
    }
    else
    {
        [UIView animateWithDuration:1 animations:^{
            self.metaMenuTableViewController.view.alpha = 0;
        }
                         completion:
         ^(BOOL completed){
             if (completed)
             {
                 self.frameworkView.hidden = true;
                 [self.metaMenuTableViewController.view removeFromSuperview];
                 self.metaMenuTableViewController = nil;
             }
         }];
    }
    self.isMetaMenuOpen = !self.isMetaMenuOpen;
    //self.metaMenuTableViewController.view.frame = CGRectMake(0, self.metaBarViewController.getHeight, self.metaMenuTableViewController.view.frame.size.width , self.metaMenuTableViewController.view.frame.size.height);
}


/**
 Initalizes the offscreenCanvas.
 */
- (void)setupOffscreenCanvas
{
    self.offscreenCanvasViewController = [[UIViewController alloc] initWithNibName:@"TSXMenuView" bundle:nil];
    [self.offscreenCanvasView addSubview:self.offscreenCanvasViewController.view];
    
    /* Gestures to trigger menu */
    self.gestureSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeMetaMenu:)];
    self.gestureSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.applicationView addGestureRecognizer:self.gestureSwipeRight];
    self.gestureSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeMetaMenu:)];
    self.gestureSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.applicationView addGestureRecognizer:self.gestureSwipeLeft];
}


#pragma mark - View Lifecylce

/**
 Handles screen-rotation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        return true;
    }
    else
    {
        return false;
    }
}

/**
 Hides StatusBar.
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Application View-Layer

/**
 Adds a view to the ApplicationView.
 */
- (void)applicationViewAddView:(UIView*)view
{
    [self.applicationView addSubview:view];
}

/**
 Adds a view to the ApplicationView.
 */
- (void)frameworkViewAddView:(UIView*)view
{
    [self.frameworkView addSubview:view];
}

/**
 Removes all views from the ApplicationView.
 */
- (void)applicationViewRemoveAllViews
{
    for (UIView *view in self.applicationView.subviews)
    {
        [view removeFromSuperview];
    }
}

/**
 Removes FrameworkView.
 */
- (void)frameworkViewRemoveAllViews
{
    for (UIView *view in self.frameworkView.subviews)
    {
        [view removeFromSuperview];
    }
}


#pragma mark - Application Singletone Patterns


+ (SBApplicationModel*) model
{
    return [SBApplicationModel instance];
}


- (ResourceManager*)resources
{
	return [ResourceManager instance];
}

#pragma mark - Navigation-Layer

/**
 Executes a ViewController.
 */
- (void)execute:(NSString*)name
{
    @synchronized(self)
    {
        //#z: Move this to setup later.
        if (self.activeController != nil)
        {
            [[ApplicationManager instance]applicationViewRemoveAllViews];
            self.activeController = nil;
        }
    
        [self setControllerWithName:name];
        [self show];
    }
}

/**
 Returns Controller for Application Module.
 */
-  (void)setControllerWithName:(NSString*)nameNIB
{
    if ([nameNIB isEqual:@"DebugView"])
    {
        self.activeController = [[SBDebugViewController alloc] initWithNibName:@"SBDebugViewController" bundle:nil];
    }
    else if ([nameNIB isEqual:@"HealthStream"])
    {
        self.activeController = [[SBHealthStreamTableViewController alloc] initWithNibName:@"SBHealthStreamTableViewController" bundle:nil];
    }
    else if ([nameNIB isEqual:@"Login"])
    {
        self.activeController = [[SBLoginViewController alloc] initWithNibName:@"SBLoginViewController" bundle:nil];
    }
    else
    {
        NSAssert(false, @"ExecutionTag not found");
    }
}

/**
 Sets current UIViewController.
 */
- (void)show
{
    [[ApplicationManager instance] applicationViewRemoveAllViews];
    self.activeController.view.frame = [ApplicationManager getApplicationBounds];
    [self applicationViewAddView:self.activeController.view];
}

#pragma mark - Application Properties (Class Methods)

/**
 Gets Application Wide Orientation Frame.
 */
+ (CGRect) getApplicationFrame
{
    return [[UIScreen mainScreen] applicationFrame];
}

/**
 Returns the screen bounds for dynamic layouts.
 */
+ (CGRect)getApplicationBounds
{
    return [[UIScreen mainScreen] bounds];
}

/**
 Gets application bounds.
 */
+ (CGRect)getScreenFrame
{

    return [UIScreen mainScreen].bounds;
}

/**
 Gets screen height.
 */
+ (int)getScreenHeight
{
    return [[UIScreen mainScreen] applicationFrame].size.height;
}

/**
 Gets screen width.
 */
+ (int)getScreenWidth
{
    return [[UIScreen mainScreen] applicationFrame].size.width;
}

/**
 Gets application version.
 */
+ (NSString *)getApplicationVersion
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleVersion"];
}

/**
 Gets application name.
 */
+ (NSString *)getApplicationName
{
    return @"Slimbox V1.0";
}

/**
 Get NIB.
 */
+ (UINib*)getNib:(NSString*)name
{
    return [UINib nibWithNibName:name bundle:nil];
}


/**
 Get NIB.
 */
+ (void)getNib:(NSString*)name owner:(id)owner
{
    [[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil];
}

/**
 Register a table cell from a NIB.
 */
+ (void) registerTableCell:(NSString*)name tableView:(UITableView*)tableView cellResudeIndentifier:(NSString*)identifier
{
    [tableView registerNib:[ApplicationManager getNib:name]forCellReuseIdentifier:identifier];
}

/**
 Random Float. 
 */
+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

/**
 Colors.
 */
+ (UIColor *)colorWithHexString:(NSString *)str {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

/**
 Handles System Errors.
 */
- (void)systemError:(NSString*)errorStringTag error:(NSError*)error option:(NSNumber*)option completionBlock:(void(^)())completionBlock
{
    // Alert-Error
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[ApplicationManager translate:@"Fehlermeldung"] message:[ApplicationManager translate:errorStringTag] delegate:self cancelButtonTitle:[ApplicationManager translate:@"Ok"] otherButtonTitles:nil];
    [alert show];
}

/**
 Alert-View Delegate for System-Errors.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // #t: Insert-Alert Delegate
}

/**
 Get localized string from text. #t: Make possible for Arrays and dictionaries.
 */
+ (NSString*)translate:(NSString*)text
{
    return NSLocalizedString(text, nil);
}

+ (NSDate*)stringToDate:(NSString*)dateString
{
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"dd/mm/yyyy"];
    NSDate *date = [inFormat dateFromString:dateString];
    return date;
}

/**
 */
+ (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-mm-yyyy"];
    return [formatter stringFromDate:date];
}

/**
 */
+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
