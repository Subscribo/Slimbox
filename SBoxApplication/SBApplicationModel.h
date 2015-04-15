/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#import <UIKit/UIKit.h>
#import "PUser.h"
#import "Singleton.h"
#import <ReactiveCocoa.h>

typedef enum {
    kSBRegisterWithEmail,
    kSBRegisterWithTwitter,
    kSBRegisterWithFacebook
} kSBRegister;

typedef enum
{
    kSBEventsLoadInitital,
    kSBEventsLoadNext,
    kSBEventsLoadPrevious
} kSBEventsLoad;

@interface SBApplicationModel : NSObject
SingletonInit

@property (nonatomic, strong) PUser *currentUser; // Current User Object
@property (nonatomic, strong) NSMutableArray *hsItemsCache; // Cache which containss all loaded items

- (void)initModelWithApplicationID:(NSString*)applicationID clientID:(NSString*)clientID;
- (void)userLoggedIn:(RACSubject*)subject;
- (BOOL)getUserObject;
- (void)createObjectRegisterWith:(kSBRegister)type;
- (void)loadNext:(RACSubject*)subject option:(kSBEventsLoad)option;
- (void)setupMockupDataForUser;
- (PUser*)getUser;

@end
