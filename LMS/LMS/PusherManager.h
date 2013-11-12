//
//  PusherManager.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PTPusher.h>

@interface PusherManager : NSObject <PTPusherDelegate>

@property (nonatomic, strong) PTPusher *pusher;

- (id)initWithAPIKey:(NSString *)APIkey;

- (PTPusherChannel *)subscribeToDefaultChannel;
- (PTPusherChannel *)subscribeToChannelName:(NSString *)channelName;

@end
