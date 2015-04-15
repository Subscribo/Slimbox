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


@protocol WeaklyReferencedFBUtils <NSObject>

// FBSDKv3
+ (void)logInWithPermissions:(NSArray *)permissions block:(PFUserResultBlock)block;
// FBSDKv4
+ (void)logInInBackgroundWithReadPermissions:(NSArray *)permissions block:(PFUserResultBlock)block;
+ (void)logInInBackgroundWithPublishPermissions:(NSArray *)permissions block:(PFUserResultBlock)block;

@end


@interface SlimboxServices ()


@end


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
 New Facebook-Login
 */
- (RACSignal*)loginWithFacebook
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
 
        PFUserResultBlock resultBlock = ^(PFUser *user, NSError *error) {
            if (user)
            {
                if (user.isNew)
                {
                    Log(10, [ApplicationManager translate:@"FacebookUserLoggedInNew"], @"");
                    [subscriber sendNext:user];
                    [subscriber sendCompleted];
                }
                else
                {
                    Log(10, [ApplicationManager translate:@"FacebookUserLoggedInOld"], @"");
                    [subscriber sendNext:user];
                    [subscriber sendCompleted];
                }
            }
            else if (error)
            {
                [subscriber sendError:error];
            }
            else
            {
            }
        };
    
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email"];
        
        [PFFacebookUtils initializeFacebook];
        
        Class fbUtils = NSClassFromString(@"PFFacebookUtils");
        if ([fbUtils respondsToSelector:@selector(logInWithPermissions:block:)])
        {
            // Facebook SDK v3 Login
            [fbUtils logInWithPermissions:permissionsArray block:resultBlock];
        }
        else if ([fbUtils respondsToSelector:@selector(logInInBackgroundWithReadPermissions:block:)])
        {
            // Facebook SDK v4 Login
            if ([self permissionsContainsFacebookPublishPermission:permissionsArray]) {
                [fbUtils logInInBackgroundWithPublishPermissions:permissionsArray block:resultBlock];
            }
            else
            {
                [fbUtils logInInBackgroundWithReadPermissions:permissionsArray block:resultBlock];
            }
        } else
        {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Can't find PFFacebookUtils. Please link with ParseFacebookUtils or ParseFacebookUtilsV4 to enable login with Facebook."];
        }
        return nil;
    }];
}

- (BOOL)permissionsContainsFacebookPublishPermission:(NSArray *)permissions {
    for (NSString *permission in permissions) {
        if ([permission hasPrefix:@"publish"] ||
            [permission hasPrefix:@"manage"] ||
            [permission isEqualToString:@"ads_management"] ||
            [permission isEqualToString:@"create_event"] ||
            [permission isEqualToString:@"rsvp_event"]) {
            return YES;
        }
    }
    return NO;
}

/**
 Service fetch data from Facebook.
 */
- (RACSignal*)facebookGetUserData
{
    return [RACSignal createSignal:^RACDisposable*(id<RACSubscriber>subscriber)
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
                                         PUser *user = [[ApplicationManager model] getUser];
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
                                             user[@"surname"] = userData[@"last_name"];
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
