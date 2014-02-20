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

#import "User.h"
#import "User+Manager.h"
#import "Stickers.h"
#import "Stickers+Manager.h"

#import "AppDelegate.h"

@interface LMSMapViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Stickers *stickers;
@property (nonatomic, strong) NSMutableArray *stickerList;

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

	UITapGestureRecognizer *singleFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(handleSingleTap:)];
	[self.mapView addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
	CGPoint location = [recognizer locationInView:[recognizer.view superview]];
	
	DLog(@"location.x: %f | location.y: %f", location.x, location.y);
	
	UIViewPosition stickerListPosition = self.headerMapView.stickerMapViewButton.isToggled == YES ? leftPosition : rightPosition;
	
	if (stickerListPosition == leftPosition) {
		[self.stickerListContainer animateFromPosition:rightPosition];
		[self.headerMapView.stickerMapViewButton deselect];
	}
	
	UIViewPosition friendListPosition = self.headerMapView.friendMapViewButton.isToggled == YES ? topPosition : bottomPosition;

	if (friendListPosition == topPosition) {
		[self.friendListContainer animateFromPosition:bottomPosition];
		[self.headerMapView.friendMapViewButton deselect];
	}

	
//	[self.inputTextView.textView resignFirstResponder];
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
	
	if (self.user == nil) {
		self.user = [[User alloc] init];
#warning TO IMPLEMENT
		//TODO: get the default id from the session manager
		self.user.id = 1;
	}
	
	[self.user update:^(id object) {
		if (object) {
			self.user = (User *)object;
			DLog(@"user: %@", self.user);
			
			self.stickers = [[Stickers alloc] init];
			[self.stickers updateWithUser:self.user andBlock:^(id object) {
				DLog(@"object: %@", object);
				if (object) {
					Stickers *stickers = (Stickers *)object;
					DLog(@"stickers.stickers: %@", stickers.stickers);
					self.stickerList = [[NSMutableArray alloc] initWithArray:stickers.stickers];
					
					
					[self.mapView loadStickerList:self.stickerList];
					
					//WARNING: bad -> reload only the targeted cell
//					[self.tableView reloadData];
				}
			}];
		}
	}];
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
	NSString *channelName = @"locations_channel";
	PTPusherChannel *channel = [self.appDelegate.pusherManager subscribeToChannelName:channelName];
		
	[channel bindToEventNamed:@"new_location" handleWithBlock:^(PTPusherEvent *channelEvent) {
		DLog(@"channelEvent: %@", channelEvent);
		DLog(@"channelEvent.data: %@", [channelEvent.data objectForKey:@"location"]);

		LMSLocation *location = [[LMSLocation alloc] initWithDictionary:[channelEvent.data objectForKey:@"location"] error:nil];
		[self.mapView addLiveLocation:location];
	}];
}

#pragma mark - LMSHeaderMapViewDelegate

- (void)didToggleStickerButton:(id)sender {
	DLog(@"");
	
	UIViewPosition position = self.headerMapView.stickerMapViewButton.isToggled == YES ? leftPosition : rightPosition;
	[self.stickerListContainer animateFromPosition:position];
}

- (void)didToggleFriendButton:(id)sender {
	DLog(@"");
	
	UIViewPosition position = self.headerMapView.friendMapViewButton.isToggled == YES ? topPosition : bottomPosition;
	[self.friendListContainer animateFromPosition:position];
}

- (void)didToggleMenuButton:(id)sender {
	[self.frostedViewController presentMenuViewController];
}

#pragma mark - Basic Handlers

- (void)respondToTapGesture:(UIGestureRecognizer *)gr {
	DLog(@"TAP TAP");
	DLog(@"TAP TAP");
}

- (IBAction)autoFocusHandler:(id)sender {
	DLog(@"autoFocusHandler");
	
	self.mapView.autoFocusEnabled = !self.mapView.autoFocusEnabled;
	
	UIImage *autoFocus = (self.mapView.autoFocusEnabled == NO) ? [UIImage imageNamed:@"red_target_icon"] : [UIImage imageNamed:@"green_target_icon"];
	[self.autoFocusButton setImage:autoFocus forState:UIControlStateNormal];
}

@end
