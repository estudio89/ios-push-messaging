//
//  WebsocketHelper.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 8/1/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "WebsocketHelper.h"
#import "PushCentral.h"
#import "PushInjection.h"

@interface WebsocketHelper ()

@property (strong, nonatomic) PushConfig *pushConfig;
@property BOOL connected;
@property (strong, nonatomic) SIOSocket *socket;
@property (strong, nonatomic) NSString *currentRoom;

@end

@implementation WebsocketHelper

- (instancetype)initWithPushConfig:(PushConfig *)pushConfig
{
    self = [super init];
    
    if (self)
    {
        _pushConfig = pushConfig;
    }
    
    return self;
}

+ (WebsocketHelper *)getInstance
{
    return [PushInjection get:[WebsocketHelper class]];
}

- (void)startSocket
{
    NSString *websocketUrl = [_pushConfig getWebsocketUrl];
    NSString *registrationId = [_pushConfig getRegistrationId];
    
    if (websocketUrl == nil || registrationId == nil || _connected || _socket != nil) {
        return;
    }
    
    [SIOSocket socketWithHost:websocketUrl
       reconnectAutomatically:YES
                 attemptLimit:-1
                    withDelay:1
                 maximumDelay:5
                      timeout:20
                     response: ^(SIOSocket *socket) {
                         _socket = socket;
                         
                         // connect
                         _socket.onConnect = ^() {
                             _connected = YES;
                             NSDictionary *jsonObject = @{@"identifier":@"ios",
                                                          @"deviceId":registrationId};
                             [_socket emit:@"register" args:@[jsonObject]];
                         };
                         
                         // disconnect
                         _socket.onDisconnect = ^() {
                             _connected = NO;
                         };
                         
                         for (NSString *identifier in [_pushConfig getPushManagerIdentifiers])
                         {
                             [_socket on:identifier callback:^(NSArray *args) {
                                 NSLog(@"==============> WebsocketHelper: push has arrived.");
                                 NSDictionary *pushData = [args objectAtIndex:0];
                                 [PushCentral onHandleRemoteNotification:pushData
                                                   withCompletionHandler:nil];
                             }];
                         }
                               }];
}

- (void)join:(NSString *)roomName
{
    if (roomName == nil || _socket == nil || !_connected) {
        return;
    }
    
    _currentRoom = roomName;
    [_socket emit:@"joinRoom" args:@[roomName]];
}

- (void)leave:(NSString *)roomName
{
    if (roomName == nil || _socket == nil || !_connected || _currentRoom == nil) {
        return;
    }
    
    [_socket emit:@"leaveRoom" args:@[]];
    _currentRoom = nil;
}

- (void)sendToRoom:(NSString *)roomName withEventName:(NSString *)eventName withData:(NSDictionary *)data
{
    if (roomName == nil || _socket == nil || !_connected) {
        return;
    }
    
    if (![roomName isEqualToString:_currentRoom]) {
        if (_currentRoom != nil) {
            [self leave:_currentRoom];
        }
        
        [self join:roomName];
    }
    
    NSDictionary *jsonObj = @{@"eventName":eventName,
                              @"eventData":data};
    
    [_socket emit:@"sendToRoom" args:@[jsonObj]];
}

- (void)on:(NSString *)eventName withBlock:(void (^)(NSArray *))block
{
    if (_socket == nil || !_connected) {
        return;
    }
    
    [_socket on:eventName callback:block];
}

@end
