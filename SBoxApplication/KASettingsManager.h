//
//  KASettingsManager.h
//  Kochabo
//
//  Created by Botond Kis on 22.11.12.
//  Copyright (c) 2012 aaa - AllAboutApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"

/* =======================================================================
 Notification Keys
 */
// notification will be thrown when the app was updated to a newer version
extern NSString * const kNotificationSettingsAppUpdateOccured;

// notification will be thrown when any settings where changed
extern NSString * const kNotificationSettingsChanged;


/* =======================================================================
 Enums */
// -------------------------
// Enum for Region selection

typedef enum {
    KASettingsRegionNone,
    KASettingsRegionGermany,
    KASettingsRegionAustria,
    KASettingsRegionSwiss
} KASettingsRegion;

// -------------------------
// Enum for FoodType selection

typedef enum {
    KASettingsFoodTypeNone,
    KASettingsFoodTypeClassic,
    KASettingsFoodTypeVeggie,
    KASettingsFoodTypeTrueManOnlyEatBaconARRRR
} KASettingsFoodType;



/* =======================================================================
 SettingsManager handles and stores the user Settings in the userdefaults
 Stores stuff like the Region, Veggie or Classic and similar stuff
 
 Uses the singleton pattern
*/

@interface KASettingsManager : NSObject

// -------------------------
// Returns the instance of the settingsmanager
+ (KASettingsManager *) sharedSettingsManager;

- (void)resetSettings;

// -------------------------
// Properties

/* userRegion
 *Not selectable!
 * Each country has his own build.
 * You build it via the schemes.
 */
@property (nonatomic, readonly) KASettingsRegion userRegion;
- (KASettingsRegion)userRegion;

@property KASettingsFoodType userFoodType;
- (KASettingsFoodType)userFoodType;
- (void)setUserFoodType:(KASettingsFoodType)region;

@property (nonatomic, assign) NSString *userLastMail;
- (NSString *)userLastMail;
- (void)setUserLastMail:(NSString *)mail;

@property (nonatomic) BOOL *isUserLogedInWithEMail;

// -------------------------
// Login
- (void)loginUserWithUsername:(NSString *)userName password:(NSString *)pw andCompletitionBlock:(void(^)(BOOL success, NSString *error))completitionBlock;

- (void)logoutUserWithCompletitionBlock:(void(^)(BOOL success))completitionBlock;

- (void)isuserLoggedInWithCompletitionBlock:(void(^)(BOOL isLoggedIn))completitionBlock;

- (void)getUserInfoWithCompletitionBlock:(void(^)(BOOL success, NSString *firstName, NSString *lastName))completitionBlock;

@end
