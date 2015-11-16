//
//  PushCentral.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 3/16/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "PushCentral.h"
#import "PushConfig.h"
#import <Syncing/Syncing.h>

@implementation PushCentral
{
    void (^_completionHandler)(UIBackgroundFetchResult);
}

/**
 * onHandleRemoteNotification
 */
+ (void)onHandleRemoteNotification:(NSDictionary *)userInfo withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([userInfo count] > 0 && [userInfo valueForKey:@"type"])
    {
        PushConfig *pushConfig = [PushConfig getInstance];
        NSString *type = [userInfo valueForKey:@"type"];
        
        long long timestamp = [[userInfo valueForKey:@"timestamp"] longLongValue];
        long long storedTimestamp = [[pushConfig getTimestamp] longLongValue];
        
        if (timestamp <= storedTimestamp) {
            if (completionHandler != nil && ![completionHandler isKindOfClass:[NSNull class]]) {
                completionHandler(UIBackgroundFetchResultNewData);
            }
            
            return;
        }
        
        [pushConfig setTimestamp:[NSString stringWithFormat:@"%lld", timestamp]];
        
        id<PushManager> manager = [pushConfig getPushManager:type];
        if (manager != nil)
        {
            [manager processPushMessage:userInfo withCompletionHandler:completionHandler];
        }
    }
}

@end
