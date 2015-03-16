//
//  PushManager.h
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 3/16/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PushManager <NSObject>

- (NSString *)getIdentifier;
- (void)processPushMessage:(NSDictionary *)data;

@end
