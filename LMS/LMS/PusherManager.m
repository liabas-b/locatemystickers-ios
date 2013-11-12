//
//  PusherManager.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "PusherManager.h"

static NSString *kDefaultPusherAPIKey = @"ba676f4f7e8139bcf138";
static NSString *kDefaultChannelName = @"test_channel";

@implementation PusherManager

- (id)init {
	self = [super init];
	
	if (self) {
		self.pusher = [PTPusher pusherWithKey:kDefaultPusherAPIKey delegate:self encrypted:YES];
	}
	return  self;
	
}

- (id)initWithAPIKey:(NSString *)APIkey {
	self = [super init];
	
	if (self) {
		self.pusher = [PTPusher pusherWithKey:APIkey delegate:self encrypted:YES];
	}
	return  self;
}

#pragma mark -
#pragma mark Default

- (PTPusherChannel *)subscribeToDefaultChannel {
	return [self.pusher subscribeToChannelNamed:kDefaultChannelName];
}

- (PTPusherChannel *)subscribeToChannelName:(NSString *)channelName {
	return [self.pusher subscribeToChannelNamed:channelName ? channelName : kDefaultChannelName];
}

#pragma mark -
#pragma mark Pusher Delegate

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection {
	DLog(@"Pusher: Connected");
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error {
	DLog(@"Pusher: Disconnected with error: %@", error);
}
- (void)pusher:(PTPusher *)pusher connectionWillReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay {
	DLog(@"Pusher: Reconnected after delay: %f", delay);
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request {
	DLog(@"Pusher: will authorize Channel with request: %@", request);
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel {
	DLog(@"Pusher: subscribeed to channel: %@", channel);
}

- (void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel {
	DLog(@"Pusher: unsubscribeed to channel: %@", channel);
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error {
	DLog(@"Pusher: failed to subscribe to channel: %@ with error: %@", channel, error);
}

- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent {
	DLog(@"Pusher: pusher: %@ with errorEvent: %@", pusher, errorEvent);
}

@end
