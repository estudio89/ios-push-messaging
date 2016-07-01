//
//  PushInjection.h
//  ios-push-messaging
//
//  Created by Rodrigo Suhr on 5/5/15.
//  Copyright (c) 2015 Estúdio 89 Desenvolvimento de Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushInjection : NSObject

+ (void)initWithConfigFile:(NSString *)fileName withBaseUrl:(NSString *)baseUrl;
+ (void)executeInjection;
+ (id)get:(Class)class;

@end
