//
//  PushInjection.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 5/5/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushInjection.h"
#import "PushConfig.h"
#import "WebsocketHelper.h"
#import <Raven/RavenClient.h>
#import <Syncing/Syncing.h>

@implementation PushInjection

static NSMutableDictionary *objects;

+ (void)initWithConfigFile:(NSString *)fileName
{
    [self configRavenClient];
    [self executeInjection];
    
    [[PushConfig getInstance] setConfigFile:fileName];
    
    // send some information to sentry
    SyncConfig *syncConfig = [[SyncConfig alloc] init];
    [RavenClient sharedClient].user = @{@"token":[syncConfig getAuthToken],
                                        @"user":[syncConfig getUsername],
                                        @"model":[NSString stringWithFormat:@"%@, %@", [UIDevice currentDevice].model, [UIDevice currentDevice].localizedModel]};
}

+ (void)executeInjection
{
    PushConfig *pushConfig = [[PushConfig alloc] init];
    WebsocketHelper *wsh = [[WebsocketHelper alloc] initWithPushConfig:pushConfig];
    
    objects = [[NSMutableDictionary alloc] init];
    
    [objects setObject:pushConfig forKey:NSStringFromClass([pushConfig class])];
    [objects setObject:wsh forKey:NSStringFromClass([wsh class])];
}

+ (id)get:(Class)class
{
    return [objects objectForKey:NSStringFromClass(class)];
}

+ (void)configRavenClient
{
    //raven client configuration
    RavenClient *ravenClient = [RavenClient clientWithDSN:@"http://7c2c45b4fd0443098cec6739ad8785a8:c5c4826fbec942fda38e7eb94fa25307@sentry.estudio89.com.br/4"];
    [RavenClient setSharedClient:ravenClient];
    
    //global error handler
    [[RavenClient sharedClient] setupExceptionHandler];
}

@end
