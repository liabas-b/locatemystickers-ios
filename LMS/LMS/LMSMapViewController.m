//
//  LMSMapViewController.m
//  LMS
//
//  Created by Adrien Guffens on 02/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapViewController.h"
#import "LMSHeaderMapView.h"
#import "LMSMapView.h"
#import "LMSSticker+Manager.h"

#import "UIView+Animations.h"

#import "WebSocketManager.h"

#import "PusherManager.h"
#import <PTPusherChannel.h>
#import <PTPusherEvent.h>


#import "LMSLocation.h"
#import "LMSLocation+Manager.h"

#import "LMSSticker.h"
#import "LMSSticker+Manager.h"

#import "AppDelegate.h"

@interface LMSMapViewController ()

@end

@implementation LMSMapViewController

#pragma mark - Configure

- (void)configure {
	[super configure];
	
	[self configureView];
	[self registerNibs];
	[self setupData];
	[self setupView];
	
	[self handleMessagePusher];
//	[self.appDelegate.pusherManager.pusher sendEventNamed:@"my_event" data:@"Hello World 42 42" channel:@"test_channel"];
}

#pragma mark - Base logic

- (void)configureView {
	[super configureView];
	self.headerMapView.delegate = self;
}

- (void)registerNibs {
	[super registerNibs];
}

- (void)setupData {
	[super setupData];
}

- (void)setupView {
	[super setupView];
	
	[self loadStickerList];
}

#pragma mark - View controller life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleMessageWebSocket:)
												 name:kMessageWebSocketReceived
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebSocket

- (void)handleMessageWebSocket:(NSNotification *)notification {
    NSString *message = (NSString *)[notification object];
	
	NSLog(@"%s | message: %@", __PRETTY_FUNCTION__, message);
	//TODO: do some stuff if the message is good
	
    if (message != nil) {
//        NSNumber *n = [theData objectForKey:@"isReachable"];
//        BOOL isReachable = [n boolValue];
//        NSLog(@"reachable: %d", isReachable);
    }
}

#pragma mark - Main logic

- (void)loadStickerList {
	NSArray *stickerRecordList = [[NSMutableArray alloc] init];//[StickerRecord findAllSortedBy:@"createdAt" ascending:NO];
	NSLog(@"%s | stickerRecordList: %@", __PRETTY_FUNCTION__, stickerRecordList);
	
	[self.mapView loadStickerList:stickerRecordList];
}

#pragma mark - Pusher Manger

- (void)handleMessagePusher {
	NSString *channelName = [NSString stringWithFormat:@"%d_locations_channel", 1];
	PTPusherChannel *channel = [self.appDelegate.pusherManager subscribeToChannelName:channelName];
		
	[channel bindToEventNamed:@"my_event" handleWithBlock:^(PTPusherEvent *channelEvent) {
		DLog(@"channelEvent: %@", channelEvent);
		DLog(@"channelEvent.data: %@", [channelEvent.data objectForKey:@"message"]);
		//NEW STICKER:

//		LMSSticker *sticker = [LMSSticker addUpdateWithDictionary:nil];
		
		//NEW LOCATION:
		
	}];
}

#pragma mark - LMSHeaderMapViewDelegate

- (void)didToggleStickerButton:(id)sender {
	DLog(@"");
	
	[self.frostedViewController presentMenuViewController];
	
	UIViewPosition position = self.headerMapView.stickerMapViewButton.isToggled == YES ? leftPosition : rightPosition;
	[self.stickerListContainer animateFromPosition:position];
}

- (void)didToggleFriendButton:(id)sender {
	DLog(@"");
//	[self.appDelegate.pusherManager.pusher sendEventNamed:@"my_event" data:@"{\"message\":\"hello 4242424242\"}" channel:@"test_channel"];
	
	UIViewPosition position = self.headerMapView.friendMapViewButton.isToggled == YES ? topPosition : bottomPosition;
	[self.friendListContainer animateFromPosition:position];
}

@end
