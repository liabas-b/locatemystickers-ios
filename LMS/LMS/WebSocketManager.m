//
//  WebSocketManager.m
//  LMS
//
//  Created by Adrien Guffens on 03/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "WebSocketManager.h"

static double kFrequencyConnectLoop = 2.0;

@interface WebSocketManager ()

@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSTimer *connectTimer;

@property (nonatomic, assign) BOOL connectionIsOpen;
@property (nonatomic, assign) BOOL isTryingToConnect;

@property (nonatomic, strong) NSString *currentState;

@end

@implementation WebSocketManager

- (id)initWithHostName:(NSString *)hostName {
	self = [super init];
	if (self) {
		self.hostName = hostName;
		[self reconnect];
	}
	return  self;
}

#pragma mark - SRWebSocket

- (void)reconnect
{
	[self invalidateConnectTimer];
	[self closeWebSocket];
	
	_webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.hostName]]];
	_webSocket.delegate = self;
	
	self.currentState = @"Opening Connection...";
	//	_connectionButton.style = UIBarButtonSystemItemStop;
	[_webSocket open];
	[self displayStatus];
}


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    self.currentState = @"Connected!";
	
	[self invalidateConnectTimer];
	
	_connectionIsOpen = YES;
	
//	UIBarButtonItem *pauseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(reconnect)];
//	self.navigationItem.leftBarButtonItem = pauseItem;
	[self displayStatus];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.currentState = @"Connection Failed! (trying to connect)";
	
	//	[self closeWebSocket];
	
	self.connectionIsOpen = NO;
	//_isTryingToConnect = NO;
	
	self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:kFrequencyConnectLoop target:self selector:@selector(reconnect) userInfo:nil repeats:YES];
	NSLog(@"Trying to conect to %@...", self.hostName);
	[self displayStatus];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
	NSLog(@"Received a message");
//	NSLog(@"Received \"%@\"", message);
	
	NSLog(@"%s | %d", __PRETTY_FUNCTION__, [(NSString *)message length]);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, message);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kMessageWebSocketReceived object:message];
	
//	NSData *data = (NSData *)message;
	
//	_imageView.image = nil;
//	_imageView.image = [UIImage imageWithData:data];//[self imageFromText:(NSString * )message];//image;//[UIImage imageWithData:imageData];
	
	
//	[self writeImageToFile:_imageView.image];
	/*
	 NSString *text = [NSString stringWithFormat:@"%d bytes received", [(NSString *)message length]];
	 [_messageList addObject:[[BMessage alloc] initWithMessage:text fromMe:NO]];
	 [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messageList.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
	 
	 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	 */
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.currentState = @"Connection Closed! (see logs)";
	
	[self displayStatus];
	
	NSLog(@"%s | code: %d | reason: %@ | wasClean: %@", __PRETTY_FUNCTION__, code, reason, wasClean == YES ? @"Clean" : @"Not Clean");
	
	//	[self closeWebSocket];
	
	if (wasClean == NO) {
		_connectionIsOpen = NO;
		
		[self invalidateConnectTimer];
		
		[self runScheduledConnectTimer];
	}
}

- (void)runScheduledConnectTimer {
	_connectTimer = [NSTimer scheduledTimerWithTimeInterval:kFrequencyConnectLoop target:self selector:@selector(reconnect) userInfo:nil repeats:YES];
	
	NSLog(@"Trying to conect to %@...", self.hostName);
}

#pragma mark - Helper

- (void)invalidateConnectTimer {
	[_connectTimer invalidate];
	_connectTimer = nil;
}

- (void)closeWebSocket {
	_webSocket.delegate = nil;
	[_webSocket close];
	_webSocket = nil;
}

- (void)displayStatus {
	NSLog(@"%s | currentState: %@", __PRETTY_FUNCTION__, self.currentState);
}

#pragma mark - Action

- (IBAction)connectionToggleHandler:(id)sender {
	
	if (_isTryingToConnect == YES) {
		NSLog(@"%s | %@",  __PRETTY_FUNCTION__, @"STOP TRYING TO CONNECT");
		
		[self invalidateConnectTimer];
		
		_isTryingToConnect = NO;
		[self closeWebSocket];
		/*
		UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(connectionToggleHandler:)];
		self.navigationItem.leftBarButtonItem = playItem;
		 */
	}
	else {
		NSLog(@"%s | %@",  __PRETTY_FUNCTION__, @"START TRYING TO CONNECT");
		_isTryingToConnect = YES;
		[self runScheduledConnectTimer];
		
		/*
		UIBarButtonItem *pauseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(connectionToggleHandler:)];
		self.navigationItem.leftBarButtonItem = pauseItem;
		 */
	}
}



@end
