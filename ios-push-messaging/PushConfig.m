//
//  PushConfig.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 3/16/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushConfig.h"
#import <Syncing/Syncing.h>

@interface PushConfig()

@property (nonatomic, strong, readwrite) NSString *mConfigFile;
@property (nonatomic, strong, readwrite) NSString *serverRegistrationUrl;
@property (nonatomic, strong, readwrite) NSMutableDictionary *pushManagersByIdentifier;
@property BOOL runningRegistration;

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
        _runningRegistration = NO;
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
    @try
    {
        NSString *jsonStr = [[NSString alloc] initWithContentsOfFile:_mConfigFile encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *jsonConfig = [jsonData objectForKey:@"pushMessaging"];
        
        _serverRegistrationUrl = [jsonConfig valueForKey:@"serverRegistrationUrl"];
        NSArray *pushManagersJson = [jsonConfig objectForKey:@"pushManagers"];
        
        id<PushManager> pushManager;
        Class klass;
        NSString *identifier = @"";
        
        for (NSString *pushManagerJson in pushManagersJson)
        {
            klass = NSClassFromString(pushManagerJson);
            pushManager = [[klass alloc] init];
            identifier = [pushManager getIdentifier];
            [_pushManagersByIdentifier setObject:pushManager forKey:identifier];
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
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

/**
 * setRegistrationId
 */
- (void)setRegistrationId:(NSString *)registrationId
{
    //set the new registration id
    [[NSUserDefaults standardUserDefaults] setValue:registrationId forKey:@"E89.iOS.PushMessaging-RegistrationId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * getRegistrationId
 */
- (NSString *)getRegistrationId
{
    NSString *registrationId = @"";
    NSString *storedRegistrationId = [[NSUserDefaults standardUserDefaults] stringForKey:@"E89.iOS.PushMessaging-RegistrationId"];
    
    if ([storedRegistrationId length] > 0)
    {
        registrationId = storedRegistrationId;
    }
    
    return registrationId;
}

/**
 * performRegistrationIfNeeded
 */
- (void)performRegistrationIfNeeded:(NSString *)registrationId
{
    SyncConfig *syncConfig = [[SyncConfig alloc] init];
    NSString *token = [syncConfig getAuthToken];
    NSLog(@"performRegistrationIfNeeded token = %@", token);
    
    if ([token length] > 0 && !_runningRegistration)
    {
        registrationId = [registrationId stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        registrationId = [registrationId stringByReplacingOccurrencesOfString:@" " withString:@""];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            @try
            {
                _runningRegistration = YES;
                NSLog(@"Starting device registration");
                
                //get old registration id, if exist
                NSString *oldRegistrationId = [self getRegistrationId];
                if ([oldRegistrationId length] == 0)
                {
                    oldRegistrationId = @"";
                }
                
                NSDictionary *parameters = @{@"token":token,
                                   @"registration_id":registrationId,
                               @"old_registration_id":oldRegistrationId,
                                          @"platform":@"ios"};
                
                ServerComm *serverComm = [[ServerComm alloc] init];
                [serverComm post:_serverRegistrationUrl withData:parameters];
                NSLog(@"Registration Id was sent");
                
                [self setRegistrationId:registrationId];
                [syncConfig setDeviceId:registrationId];
                NSLog(@"Registration Id was set. [%@]", registrationId);
            }
            @finally
            {
                _runningRegistration = NO;
            }
        });
    }
}

@end
