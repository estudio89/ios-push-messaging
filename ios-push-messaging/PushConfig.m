//
//  PushConfig.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 3/16/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushConfig.h"

@interface PushConfig()

@property (nonatomic, strong, readwrite) NSString *mConfigFile;
@property (nonatomic, strong, readwrite) NSString *serverRegistrationUrl;
@property (nonatomic, strong, readwrite) NSMutableDictionary *pushManagersByIdentifier;

@end

@implementation PushConfig

/**
 * init
 */
- (id)init
{
    if (self = [super init])
    {
        _pushManagersByIdentifier = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

/**
 * setConfigFile
 */
- (void)setConfigFile:(NSString *)filename
{
    _mConfigFile = filename;
    [self loadSettings];
}

/**
 * loadSettings
 */
- (void)loadSettings
{
    
}

/**
 * getPushManager
 */
- (id<PushManager>)getPushManager:(NSString *)identifier
{
    return [_pushManagersByIdentifier objectForKey:identifier];
}

/**
 * registerForRemoteNotification
 */
- (void)registerForRemoteNotification:(UIApplication *)app forTypes:(UIUserNotificationType)types forDevice:(UIDevice *)device
{
    if ([[device systemVersion] floatValue] >= 8.0)
    {
        [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types categories:nil]];
        [app registerForRemoteNotifications];
    }
    else
    {
        [app registerForRemoteNotificationTypes:(UIRemoteNotificationType)types];
    }
}

@end
