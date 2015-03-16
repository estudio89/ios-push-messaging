//
//  PushCentral.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 3/16/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushCentral.h"
#import "PushConfig.h"

@implementation PushCentral

/**
 * onHandleRemoteNotification
 */
- (void)onHandleRemoteNotification:(NSDictionary *)userInfo
{
    if ([userInfo count] > 0 && [userInfo valueForKey:@"type"])
    {
        NSString *type = [userInfo valueForKey:@"type"];
        PushConfig *pushConfig = [[PushConfig alloc] init];
        
        id<PushManager> manager = [pushConfig getPushManager:type];
        if (manager != nil)
        {
            [manager processPushMessage:userInfo];
        }
    }
}

@end
