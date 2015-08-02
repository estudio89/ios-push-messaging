//
//  WebsocketHelper.h
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 8/1/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SIOSocket/SIOSocket.h>
#import "PushConfig.h"

@interface WebsocketHelper : NSObject

- (instancetype)initWithPushConfig:(PushConfig *)pushConfig;
+ (WebsocketHelper *)getInstance;
- (void)startSocket;
- (void)join:(NSString *)roomName;
- (void)leave:(NSString *)roomName;
- (void)sendToRoom:(NSString *)roomName withEventName:(NSString *)eventName withData:(NSDictionary *)data;
- (void)on:(NSString *)eventName withBlock:(void (^)(NSArray *))block;

@end
