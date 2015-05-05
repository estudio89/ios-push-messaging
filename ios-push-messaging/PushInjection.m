//
//  PushInjection.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 5/5/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushInjection.h"
#import "PushConfig.h"

@implementation PushInjection

static NSMutableDictionary *objects;

+ (void)initWithConfigFile:(NSString *)fileName
{
    [self executeInjection];
    
    [[PushConfig getInstance] setConfigFile:fileName];
}

+ (void)executeInjection
{
    PushConfig *pushConfig = [[PushConfig alloc] init];
    
    objects = [[NSMutableDictionary alloc] init];
    
    [objects setObject:pushConfig forKey:NSStringFromClass([pushConfig class])];
}

+ (id)get:(Class)class
{
    return [objects objectForKey:NSStringFromClass(class)];
}

@end
