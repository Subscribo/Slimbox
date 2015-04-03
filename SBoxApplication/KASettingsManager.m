//
//  KASettingsManager.m
//  Kochabo
//
//  Created by Botond Kis on 22.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import "KASettingsManager.h"

// data
#import "KAURLManager.h"
#import "AFNetworking.h"

// ================================================
#pragma mark - Notification Keys
// ================================================
NSString * const kNotificationSettingsAppUpdateOccured  = @"com.notification.settings.updateOccured";
NSString * const kNotificationSettingsChanged           = @"com.notification.settings.changed";


// ================================================
#pragma mark - Defaults Keys
// ================================================
/*
 Type: NSString
 Stores the last installed App version
 */
static NSString *kSettingsLastAppVersion = @"com.kochabo.settings.key.lastAppVersion";


/*
 Type: KASettingsRegion/NSInteger
 Stores the Region selected by the user
 */
static NSString *kSettingsFoodType = @"com.kochabo.settings.key.foodType";

/*
 Type: KASettingsFoodType/NSInteger
 Stores the Foodtype selected by the user
 */
static NSString *kSettingsRegion = @"com.kochabo.settings.key.region";

/*
 Type: kSettingsLastMail/NSString
 Stores the last entered user name in the login
 */
static NSString *kSettingsLastMail = @"com.kochabo.settings.key.lastMail";

// ================================================
#pragma mark - KASettingsManager
// ================================================

@interface KASettingsManager ()
@property (nonatomic, strong) NSUserDefaults *_standardUSerDefaults;

// called when any settings where changed
- (void)_settingsChanged;
@end

// The single instance of this class
static KASettingsManager *_sharedInstance;

@implementation KASettingsManager

// -----------------------------------------------
#pragma mark - singleton
// -----------------------------------------------

+ (KASettingsManager *) sharedSettingsManager{
    if (!_sharedInstance) {
        _sharedInstance = [[KASettingsManager alloc] init];
    }
    
    return _sharedInstance;
}


// -----------------------------------------------
#pragma mark - Constructor
// -----------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        __standardUSerDefaults = [NSUserDefaults standardUserDefaults];
        
        // Check App Version
        NSString *lastAppVersion = [__standardUSerDefaults stringForKey:kSettingsLastAppVersion];
        NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        if (![lastAppVersion isEqualToString:currentAppVersion]) {
            [__standardUSerDefaults setObject:currentAppVersion forKey:kSettingsLastAppVersion];
            
            // throw notification if app was udpated
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSettingsAppUpdateOccured object:self];
        }
    }
    return self;
}


// -----------------------------------------------
#pragma mark - Resetter
// -----------------------------------------------

- (void)resetSettings{
    [self._standardUSerDefaults setInteger:KASettingsFoodTypeNone forKey:kSettingsFoodType];
    [self._standardUSerDefaults setInteger:KASettingsRegionNone forKey:kSettingsRegion];
    [self._standardUSerDefaults setObject:@"0" forKey:kSettingsLastAppVersion];
    
    // notifiy
    [self _settingsChanged];
}

// -----------------------------------------------
#pragma mark - Properties
// -----------------------------------------------
// Region

- (KASettingsRegion)userRegion{
#ifdef COUNTRY_AT
    return KASettingsRegionAustria;
#else 
    #ifdef COUNTRY_DE
        return KASettingsRegionGermany;
    #else
        return KASettingsRegionAustria; // use austria for debuging
    #endif
#endif
}

/*
- (void)setUserRegion:(KASettingsRegion)region{
    // store to defaults
    [self._standardUSerDefaults setInteger:region forKey:kSettingsRegion];
    
    // notifiy
    [self _settingsChanged];
}
 */


// ---------------------------
// FoodType

- (KASettingsFoodType)userFoodType{
    return (NSInteger *)[self._standardUSerDefaults integerForKey:kSettingsFoodType];
}

- (void)setUserFoodType:(KASettingsFoodType)region{
    // store to defaults
    [self._standardUSerDefaults setInteger:region forKey:kSettingsFoodType];
    
    // notifiy
    [self _settingsChanged];
}

// ---------------------------
// Username
- (NSString *)userLastMail{
    return [self._standardUSerDefaults stringForKey:kSettingsLastMail];
}

- (void)setUserLastMail:(NSString *)mail{
    
    // store to defaults
    [self._standardUSerDefaults setObject:mail forKey:kSettingsLastMail];
    
    // notifiy
    [self _settingsChanged];
}


// -----------------------------------------------
#pragma mark - User login
// -----------------------------------------------
- (void)loginUserWithUsername:(NSString *)userName password:(NSString *)pw andCompletitionBlock:(void(^)(BOOL success, NSString *error))completitionBlock{
    
    // url encode username and pw
    NSString *encodedUsername = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPW = [pw stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // make url
    NSURL *requestURL = [KAURLManager getUserLoginURLWithUserName:encodedUsername andPassword:encodedPW];
    
    // make dl request
    NSURLRequest *loginRequest = [NSURLRequest requestWithURL:requestURL
                                                    cachePolicy:NSURLCacheStorageNotAllowed
                                                timeoutInterval:URLRequestTimeOutInterval];
    
    // make download
    __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:loginRequest];
    __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
    
    requestOperation.completionBlock = ^{
        
        // safety check
        if (requestOperation.responseData == nil) {
            
            // call completition block with nil
            if (completitionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    
                    completitionBlock(NO, nil);
                });
            }
            
            return;
        }

        // parse json to cocoa
        NSError *err = nil;
        NSDictionary *parsedResponse;
        if (requestOperation.responseData) {
            parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
        }
        else{
            // call completition block with nil
            if (completitionBlock) {
                completitionBlock(NO,nil);
            }
        }
        
        // handle error
        if (objectIsNil(parsedResponse)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Error occured during parsing in loginUserWithUsername: \n%@", err);
                
                // call completition block with nil
                if (completitionBlock) {
                    completitionBlock(NO, nil);
                }
            });
            return;
        }
        
        // get success
        NSNumber *successVal = [parsedResponse objectForKey:@"success"];
        NSString *error = [parsedResponse objectForKey:@"error"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // call completition block with nil
            if (completitionBlock) {
                completitionBlock([successVal boolValue], error);
            }
        });
    };
    
    // start
    [requestOperation start];
}

- (void)logoutUserWithCompletitionBlock:(void(^)(BOOL success))completitionBlock{
    // make dl request
    NSURLRequest *logoutRequest = [NSURLRequest requestWithURL:[KAURLManager getUserLogoutURL]
                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                              timeoutInterval:URLRequestTimeOutInterval];
    
    // make download
    __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:logoutRequest];
    __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
    requestOperation.completionBlock = ^{
        
        // safety check
        if (requestOperation.responseData == nil) {
            
            // call completition block with no success
            if (completitionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    
                    completitionBlock(NO);
                });
            }
            
            return;
        }
        
        // parse json to cocoa
        NSError *err = nil;
        NSDictionary *parsedResponse;
        if (requestOperation.responseData) {
            parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
        }
        else{
            // call completition block with no success
            if (completitionBlock) {
                completitionBlock(NO);
            }
        }
        
        // handle error
        if (objectIsNil(parsedResponse)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Error occured during parsing in logoutUserWithCompletitionBlock: \n%@", err);
                
                // call completition block with success
                if (completitionBlock) {
                    completitionBlock(NO);
                }
            });
            return;
        }
        
        // get success
        NSNumber *successVal = [parsedResponse objectForKey:@"success"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // call completition block the success
            if (completitionBlock) {
                completitionBlock([successVal boolValue]);
            }
        });
    };
    
    // start
    [requestOperation start];
}

- (void)isuserLoggedInWithCompletitionBlock:(void(^)(BOOL isLoggedIn))completitionBlock{
    // make dl request
    NSURLRequest *logoutRequest = [NSURLRequest requestWithURL:[KAURLManager getUserStatusURL]
                                                   cachePolicy:NSURLCacheStorageNotAllowed
                                               timeoutInterval:URLRequestTimeOutInterval];
    
    // make download
    __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:logoutRequest];
    __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
    requestOperation.completionBlock = ^{
        
        // safety check
        if (requestOperation.responseData == nil) {
            
            // call completition block with nil
            if (completitionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post notification
                    
                    completitionBlock(NO);
                });
            }
            
            return;
        }
        
        // parse json to cocoa
        NSError *err = nil;
        NSDictionary *parsedResponse;
        if (requestOperation.responseData) {
            parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
        }
        else{
            // call completition block with nil
            if (completitionBlock) {
                completitionBlock(NO);
            }
        }
        
        // handle error
        if (objectIsNil(parsedResponse)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Error occured during parsing in isuserLoggedInWithCompletitionBlock: \n%@", err);
                
                // call completition block with nil
                if (completitionBlock) {
                    completitionBlock(NO);
                }
            });
            return;
        }
        
        // get success
        NSNumber *successVal = [parsedResponse objectForKey:@"success"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // call completition block with nil
            if (completitionBlock) {
                completitionBlock([successVal boolValue]);
            }
        });
    };
    
    // start
    [requestOperation start];
}

- (void)getUserInfoWithCompletitionBlock:(void(^)(BOOL success, NSString *firstName, NSString *lastName))completitionBlock{
    // make dl request
    NSURLRequest *infoRequest = [NSURLRequest requestWithURL:[KAURLManager getUserNameURL]
                                                   cachePolicy:NSURLCacheStorageNotAllowed
                                               timeoutInterval:URLRequestTimeOutInterval];
    
    // make download
    __block AFHTTPRequestOperation *_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:infoRequest];
    __weak AFHTTPRequestOperation *requestOperation = _requestOperation;
    requestOperation.completionBlock = ^{
    
        // safety check
        if (requestOperation.responseData == nil) {
            
            // call completition block with nil
            if (completitionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completitionBlock(NO, nil, nil);
                });
            }
            
            return;
        }
        
        // parse json to cocoa
        NSError *err = nil;
        NSDictionary *parsedResponse;
        if (requestOperation.responseData) {
            parsedResponse = [NSJSONSerialization JSONObjectWithData:requestOperation.responseData options:0 error:&err];
        }
        else{
            // call completition block with nil
            if (completitionBlock) {
                completitionBlock(NO,nil,nil);
            }
        }
        
        // handle error
        if (objectIsNil(parsedResponse)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Error occured during parsing in getUserInfoWithCompletitionBlock: \n%@", err);
                
                // call completition block with nil
                if (completitionBlock) {
                    completitionBlock(NO, nil, nil);
                }
            });
            return;
        }
        
        // get success
        NSNumber *successVal = [parsedResponse objectForKey:@"success"];
        NSString *firstName = [parsedResponse objectForKey:@"firstname"];
        NSString *lastName = [parsedResponse objectForKey:@"lastname"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // call completition block with nil
            if (completitionBlock) {
                completitionBlock([successVal boolValue], firstName, lastName);
            }
        });
    };
    
    // start
    [requestOperation start];
}


// -----------------------------------------------
#pragma mark - Private
// -----------------------------------------------

- (void)_settingsChanged{
    // sync defaults
    [self._standardUSerDefaults synchronize];
    
    // throw notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSettingsChanged object:self];
}


 - (void)setUserLogedInWithEMail {
     
     
 }

@end
