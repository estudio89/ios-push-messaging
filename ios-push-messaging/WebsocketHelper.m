//
//  WebsocketHelper.m
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 8/1/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import "WebsocketHelper.h"
#import "PushConfig.h"

@interface WebsocketHelper ()

@property (strong, nonatomic) PushConfig *pushConfig;

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

- (void)startSocket
{
    
}

@end
