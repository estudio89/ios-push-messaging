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

@implementation PushInjection

static NSMutableDictionary *objects;

+ (void)initWithConfigFile:(NSString *)fileName withBaseUrl:(NSString *)baseUrl
{
    [self executeInjection];
    
    [[PushConfig getInstance] setConfigFile:fileName withBaseUrl:baseUrl];
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

@end
