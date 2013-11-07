//
//  WebSocketManager.h
//  LMS
//
//  Created by Adrien Guffens on 03/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

static NSString *kMessageWebSocketReceived = @"MessageWebSocketReceived";

@interface WebSocketManager : NSObject <SRWebSocketDelegate>

@property (nonatomic, strong) NSString *hostName;

//INFO: Basic init
- (id)initWithHostName:(NSString *)hostName;

- (void)reconnect;
//INFO: to toggle the connection (start/stop)
- (IBAction)connectionToggleHandler:(id)sender;

- (void)displayStatus;

@end
