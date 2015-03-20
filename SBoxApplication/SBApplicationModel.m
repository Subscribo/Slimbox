/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */
#import "SBApplicationModel.h"
#import <Parse/Parse.h>
#import "RACEXTScope.h"
#import "PUser.h"
#import "ApplicationManager.h"

@implementation SBApplicationModel
SINGLETON(SBApplicationModel)

/**
 */
- (instancetype)initSingletone
{
    if (self = [super init])
    {
        [PUser registerSubclass];

    }
    return self;
}

#pragma mark - Parse Integration

/**
 Signal if user has already logged in.
 */
- (void)userLoggedIn:(RACSubject*)subject
{
    PFQuery *query = [PUser query];
    @weakify(self)
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         @strongify(self)
         if (!error)
         {
             if (objects.count > 0)
             {
                 //#n: Check for social media login?
                 self.currentUser = [objects firstObject];
                 [subject sendNext:@(true)];
             }
             else
             {
                 [subject sendNext:@(false)];
             }
            
         } else
         {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             NSLog(@"Error: %@", errorString);
         }
     }];
}

/**
 Get UserObject #t: Extend to Twitter and Email
 */
- (BOOL)getUserObject
{
    // #t: Implement Twitter and Custom.
    PFQuery *query = [PUser query];
    NSString *facebookID = [PFUser currentUser][@"fbId"];
    if (!facebookID) return false;
    [query whereKey:@"facebookID" equalTo:facebookID];

    NSArray *objects = [query findObjects];
    if (objects.count > 0)
    {
        self.currentUser = (PUser*)[objects firstObject];
        return true;
    }
    else
    {
        return false;
    }
}

/**
 */
- (void)createObjectRegisterWith:(kSBRegister)type
{
    self.currentUser = [PUser object];
    
    if (type == kSBRegisterWithEmail)
    {
        self.currentUser.name = [ApplicationManager translate:@"Please enter your first name"];
        self.currentUser.surname = [ApplicationManager translate:@"Please enter your last name"];
        self.currentUser.email = [ApplicationManager translate:@"Please enter your email"];
    }
    self.currentUser.bodysize = @(170);
    self.currentUser.bodyweight = @(70);
    self.currentUser.birthdate = [NSDate new];
}

/**
 */
- (PUser*)getUser:(NSString*)facebookID
{
    PFQuery *query = [PUser query];
    @weakify(self)
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        @strongify(self)
        self.currentUser = [objects firstObject];
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
    return nil;
}




@end
