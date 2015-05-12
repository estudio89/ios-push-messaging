//
//  PushConfig.h
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 3/16/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PushManager.h"

@interface PushConfig : NSObject

+ (PushConfig *)getInstance;
- (void)setConfigFile:(NSString *)filename;
- (id<PushManager>)getPushManager:(NSString *)identifier;
- (void)registerForRemoteNotification:(UIApplication *)app forDevice:(UIDevice *)device;
- (void)performRegistrationIfNeeded:(NSString *)registrationId;

@end
