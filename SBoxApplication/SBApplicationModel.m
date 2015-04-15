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
#import "PHealthstreamEvent.h"
#import "PHealthstreamEventNutrition.h"
#import "ApplicationManager.h"

#define DAY (60*60*24)
#define FIVEDAYS DAY*5

@implementation SBApplicationModel
Singleton(SBApplicationModel)

/**
 */
- (instancetype)initSingleton
{
    if (self = [super init])
    {
        // Register Parse-Classes
    }
    return self;
}

/**
 */
- (void)initModelWithApplicationID:(NSString*)applicationID clientID:(NSString*)clientID
{
    // do all here.
    [Parse setApplicationId:applicationID clientKey:clientID];
    [self setACL];
    [PUser registerSubclass];
    [PHealthstreamEvent registerSubclass];
    [PHealthstreamEventNutrition registerSubclass];

}

#pragma mark - Create Mockup-Data

/**
 Setup foo mockup-data.
 */
- (void)setupMockupDataForUser
{
    [self createMockupHealthStreamDataFromNowForNumberOfDays:10];
}

#pragma mark - Healthstream Data Model

/**
 Getter for cached items array.
 */
- (NSMutableArray*) hsItemsCache
{
    if (!_hsItemsCache)
    {
        _hsItemsCache = [NSMutableArray new];
    }
    return _hsItemsCache;
}

/**
 Sort items via timestamp.
 */
- (NSMutableArray*)getSortedHSItemsCache
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
    [self.hsItemsCache sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return self.hsItemsCache;
}

#pragma mark - Healthstream Data Query

/**
 Load Healthstream-Events from Parse.
 */
- (void)loadNext:(RACSubject*)subject option:(kSBEventsLoad)option
{
    if (option == kSBEventsLoadInitital)
    {
        [self getHealthstreamEventsFrom:[[NSDate new] dateByAddingTimeInterval:-FIVEDAYS] to:[[NSDate new] dateByAddingTimeInterval:FIVEDAYS]];
    }
    [subject sendNext:[self getSortedHSItemsCache]];
}


/**
 Query all Healthstream-Events between two dates.
 */
- (void)getHealthstreamEventsFrom:(NSDate*)from to:(NSDate*)to
{
    PFQuery *query = [PFQuery queryWithClassName:@"PHealthstreamEvent"];
    [query whereKey:@"timestamp" greaterThan:from];
    [query whereKey:@"timestamp" lessThan:to];
    
    NSArray *objects = [query findObjects];
    
    for (PHealthstreamEvent *object in objects)
    {
        query = [PFQuery queryWithClassName:@"PHealthstreamEventNutrition"];
        [query whereKey:@"objectId" equalTo:object.eventID];
        PHealthstreamEventNutrition *resultObject = (PHealthstreamEventNutrition*)[query getFirstObject];
        if (resultObject)
        {
            [self.hsItemsCache addObject:resultObject];
        }
    }
}


#pragma mark - ParseACL 

- (void)setACL
{
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:NO];
    [defaultACL setPublicWriteAccess:NO];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

#pragma mark - Mockup Data

/**
 Delete all mockup data in tables.
 */
- (void)deleteMockupData
{
    NSArray *deleteTables = @[@"PHealthstreamEvent", @"PHealthstreamEventNutrition"];
    
    for (NSString *table in deleteTables)
    {
        PFQuery *query = [PFQuery queryWithClassName:table];
        NSArray *test = [query findObjects];
        
        for (PFObject *object in test)
        {
            [object delete];
        }
    }
}

/**
 Create mockup data for testing the Healthstream.
 */
- (void)createMockupHealthStreamDataFromNowForNumberOfDays:(NSInteger)days
{
    // TestData for possible events
    NSArray *title = @[@"Hühnerschnitzel in Hanfpanade und Kartoffel-Vogerlsalat", @"Karfiol-Pizza", @"Handgemachte Spaghetti alla Bolognese", @"Röstgemüse mit Kichererbsendip", @"Frühlings-Käse-Wurstsalat", @"Röstgemüse mit Kichererbsendip", @"Quinoa-Tabouleh mit süßlichem Ofenpaprika", @"Ratatouille-Wraps mit Couscous", @"Zartes Hüftsteak auf Frühlings-Sprossensalat", @"Bohnen-Paprika-Chili-Eintopf"];
    
    NSArray *images = @[@"CookTestImage01.png", @"CookTestImage02.png", @"CookTestImage03.png", @"CookTestImage04.png", @"CookTestImage05.png"];
    
    NSDate *now = [NSDate new];
    NSDate *mockupDate = now;
    NSTimeInterval day = DAY;
    
    // Create Healthstream-Events for n days in the future and past
    for (int j = 0; j<2; j++)
    {
        for (int i = 0; i < days; i++)
        {
            PHealthstreamEvent *hsEvent = [PHealthstreamEvent object];
            PHealthstreamEventNutrition *hsNutrition = [PHealthstreamEventNutrition object];
            
            // Create a fake nutrition event
            hsNutrition.title = [title objectAtIndex:[ApplicationManager randomIntBetween:0 and:(title.count)-1]];
            hsNutrition.rating = @([ApplicationManager randomIntBetween:0 and:5]);
            NSString *imageName = [images objectAtIndex:[ApplicationManager randomIntBetween:0 and:(images.count)-1]];
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
            hsNutrition.image = [PFFile fileWithName:@"image.png" data:imageData];
            hsNutrition.calories  = @([ApplicationManager randomIntBetween:50 and:1600]);
            hsNutrition.timestamp = mockupDate;
            hsNutrition.buttonType = @"default";
            [hsNutrition save];
            
            hsEvent.eventID = hsNutrition.objectId;
            hsEvent.timestamp = mockupDate;
            hsEvent.type = @"Nutrition";
            BOOL isSaved = [hsEvent save];
            
            // Add date
            mockupDate= [now dateByAddingTimeInterval:day*i];
        }
        day = -(60*60*24);
    }
}


- (void)createNutrationEventWithImage:(UIImage*)image buttonType:(NSString*)buttonType calories:(NSNumber*)calories rating:(NSNumber*)rating title:(NSString*)title note:(NSString*)note
{
//    PHealthstreamEvent *hsEvent = [PHealthstreamEvent object];
//    PHealthstreamEventNutrition *hsNutrition = [PHealthstreamEventNutrition object];
//    
//    // Create a fake nutrition event
//    hsNutrition.title = title;
//    hsNutrition.rating = @([ApplicationManager randomIntBetween:0 and:5]);
//    NSString *imageName = [images objectAtIndex:[ApplicationManager randomIntBetween:0 and:(images.count)-1]];
//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
//    hsNutrition.image = [PFFile fileWithName:@"image.png" data:imageData];
//    hsNutrition.calories  = @([ApplicationManager randomIntBetween:50 and:1600]);
//    hsNutrition.timestamp = mockupDate;
//    hsNutrition.buttonType = @"default";
//    [hsNutrition save];
//    
//    hsEvent.eventID = hsNutrition.objectId;
//    hsEvent.timestamp = mockupDate;
//    hsEvent.type = @"Nutrition";
//    BOOL isSaved = [hsEvent save];
    
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
 Create a default user object.
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
 Get current User.
 */
- (PUser*)getUser
{
    if (self.currentUser == nil)
    {
        if ([PFUser currentUser] && [[PFUser currentUser] isAuthenticated])
        {
            PFQuery *query = [PFQuery queryWithClassName:@"PUser"];
            self.currentUser = (PUser*) [[query findObjects] firstObject];
            
        }
        if (self.currentUser == nil)
        {
            self.currentUser = [PUser object];
            [self.currentUser save];
        }
    }
    return self.currentUser;
}




@end
