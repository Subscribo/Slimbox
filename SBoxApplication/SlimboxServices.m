//
//  SocialMediaService.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 10.03.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SlimboxServices.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ApplicationManager.h"
#import "KARecipeManager.h"
#import "Log.h"
#import <Bolts/Bolts.h>
#import <UIImageView+AFNetworking.h>

@implementation SlimboxServices
Singleton(SlimboxServices)

/**
 Init-Service API here.
 */
- initSingleton
{
    if (self=[super init])
    {
    }
    return self;
}

#pragma mark - Social Media Services

/**
Service Login in user with Facebook.
 */
- (RACSignal*)facebookLoginUser
{
    return [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber){
        // Set permissions required from the facebook user account
        [PFFacebookUtils initializeFacebook];
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email"];
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            if (!user)
            {
                // #t: Inform User that he has to give the credentials
                NSString *errorMessage = nil;
                if (!error){
                    Log(1, [ApplicationManager translate:@"FacebookError"], @"");
                    errorMessage = @"Uh oh. The user cancelled the Facebook login.";
                } else {
                    Log(1, [ApplicationManager translate:@"FacebookError"], @"");
                    errorMessage = [error localizedDescription];
                }
                [[ApplicationManager instance]systemError:[ApplicationManager translate:@"FacebookError"]
                                                    error:nil option:nil completionBlock:nil];
                [subscriber sendError:error];
            }
            else
            {
                if (user.isNew)
                {
                    Log(10, [ApplicationManager translate:@"FacebookUserLoggedInNew"], @"");
                    [subscriber sendNext:@(true)];
                    [subscriber sendCompleted];
                } else
                {
                    Log(10, [ApplicationManager translate:@"FacebookUserLoggedInOld"], @"");
                    [subscriber sendNext:@(true)];
                    [subscriber sendCompleted];

                }
            }
        }];
        return nil;
    }];
 }

/**
 Service fetch data from Facebook.
 */
- (RACSignal*)facebookGetUserData
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber)
                         {
                             if (![[ApplicationManager model]getUserObject])
                             {
                                 Log(10, [ApplicationManager translate:@"FacebookFetchUserData"], @"");
                                 Log(10, [ApplicationManager translate:@"FacebookLoginUpdateProfileData"],@"");
                                 // Fill-User Data
                                 
                                 FBRequest *request = [FBRequest requestWithGraphPath:@"me" parameters:nil HTTPMethod:nil];
                                 [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                     if (!error) {
                                         // Parse the data received
                                         [PUser registerSubclass];
                                         PUser *user = [PUser object];
                                         NSDictionary *userData = (NSDictionary *)result;
                                         NSString *facebookID = userData[@"id"];
                                         user.facebookID = facebookID;
                                         
                                         NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                                         [[PFUser currentUser] setObject:me.objectID forKey:@"fbId"];
                                         [[PFUser currentUser] saveInBackground];
                                         
                                         if (userData[@"first_name"])
                                         {
                                             user.name = userData[@"first_name"];
                                         }
                                         
                                         if (userData[@"last_name"])
                                         {
                                             user.surname = userData[@"last_name"];
                                         }
                                         
                                         if (userData[@"email"])
                                         {
                                             NSString *email = userData[@"email"];
                                             user.email = email;
                                         }
                                         
                                         if (userData[@"birthday"])
                                         {
                                             NSString *birthdate = userData[@"birthday"];
                                             user.birthdate = [ApplicationManager stringToDate:birthdate];
                                         }
                                         
                                         // #n: Check for security risks?
                                         [user saveInBackground];
                                     }
                                     [subscriber sendNext:@(true)];
                                 }];
                                 return nil;
                            }
                            else
                            {
                                [subscriber sendNext:@(true)];
                            }
                            return nil;
                         }];
    return signal;
}


#pragma mark - RecipeServices 

/**
 Query recipe by ID
 */
+ (RACSignal*)queryRecipeWithID:(NSString*)ID 
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[KARecipeManager sharedRecipeManager] getRecipeWithID:ID andCompletitionBlock:^(KADataModelRecipe *recipe)
         {
             [subscriber sendNext:recipe];
         }];
        return nil;
    }];    
}

/**
 Load some image for imageview via REST.
 */
+ (RACSignal*)loadImageNamed:(NSString*)imageURL forImageView:(UIImageView*)imageView placeholderImage:(UIImage*)image
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL *URL = [NSURL URLWithString:imageURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        __weak UIImageView *temporary = imageView;
        [imageView setImageWithURLRequest:request placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
            [temporary setImage:image];
            [subscriber sendNext:nil];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            // #t: Do Errorhandling
        }];
        return nil;
    }];
}




@end
