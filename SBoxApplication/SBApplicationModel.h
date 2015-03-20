/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#import <UIKit/UIKit.h>
#import "PUser.h"
#import "Singletone.h"
#import <ReactiveCocoa.h>

typedef enum {
    kSBRegisterWithEmail,
    kSBRegisterWithTwitter,
    kSBRegisterWithFacebook
} kSBRegister;


@interface SBApplicationModel : NSObject
SINGLETONE

@property (nonatomic, strong) PUser *currentUser;

- (void)testUser;
- (void)userLoggedIn:(RACSubject*)subject;
- (BOOL)getUserObject;
- (void)createObjectRegisterWith:(kSBRegister)type;

@end
