//
//  PushAppDelegate.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 5/5/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushAppDelegate.h"
#import "PushConfig.h"
#import "PushCentral.h"

@implementation PushAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[PushConfig getInstance] performRegistrationIfNeeded:[deviceToken description]];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"[APNS] Register for remote notifications error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"==============> PushAppDelegate: push has arrived.");
    [PushCentral onHandleRemoteNotification:userInfo withCompletionHandler:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"==============> PushAppDelegate: push has arrived.");
    [PushCentral onHandleRemoteNotification:userInfo withCompletionHandler:completionHandler];
}

@end
