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

#import "WebSocketManager.h"

@interface LMSMapViewController ()

@end

@implementation LMSMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self configure];
}

- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebSocket

- (void)handleMessageWebSocket:(NSNotification *)notification {
    NSString *message = (NSString *)[notification object];
	
	NSLog(@"%s | message: %@", __PRETTY_FUNCTION__, message);
	
    if (message != nil) {
//        NSNumber *n = [theData objectForKey:@"isReachable"];
//        BOOL isReachable = [n boolValue];
//        NSLog(@"reachable: %d", isReachable);
    }
}

#pragma mark - Main logic

- (void)configure {
	self.headerMapView.delegate = self;
	
	//	[self.headerMapView.stickerMapViewButton addTarget:self action:@selector(myEvent:) forControlEvents:UIControlEventTouchDown];
	
	[self loadStickerList];
	//	[self animateView:self.view];//mapView.stickerSelectionCollectionView];
}

- (void)loadStickerList {
	NSArray *stickerRecordList = [[NSMutableArray alloc] init];//[StickerRecord findAllSortedBy:@"createdAt" ascending:NO];
	NSLog(@"%s | stickerRecordList: %@", __PRETTY_FUNCTION__, stickerRecordList);
	
	[self.mapView loadStickerList:stickerRecordList];
}

#pragma mark - View Helper - For test

- (void)animateView:(UIView *)view withMargin:(CGFloat)margin andDirection:(BOOL)left  {
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, view);
	static int i;
	
	[UIView animateWithDuration:0.5
						  delay:0.1
						options: UIViewAnimationCurveEaseOut
					 animations:^
	 {
		 CGRect frame = view.frame;
		 frame.origin.y = view.frame.origin.y;
		 if (left == YES) {
			 frame.origin.x -= (frame.size.width - margin);
		 }
		 else {
			 frame.origin.x += (frame.size.width - margin);
		 }
		 view.frame = frame;
	 }
					 completion:^(BOOL finished)
	 {
		 NSLog(@"Completed");
		 
	 }];
	i++;
}

#pragma mark - View helpers

- (void)animateStickerView:(UIView *)view  {
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, view);
	
	[UIView animateWithDuration:0.5
						  delay:0.1
						options: UIViewAnimationCurveEaseOut
					 animations:^
	 {
		 CGRect frame = view.frame;
		 frame.origin.y = view.frame.origin.y;
		 if (self.headerMapView.stickerMapViewButton.isToggled == NO) {
			 frame.origin.x += frame.size.width;
		 }
		 else {
			 frame.origin.x -= frame.size.width;
		 }
		 view.frame = frame;
	 }
					 completion:^(BOOL finished)
	 {
		 NSLog(@"Completed");
		 
	 }];
	/*
	return;
	CGRect rect = view.frame;
	CGRect originalRect = rect;
	rect.origin.y = -rect.size.height;
	view.frame = rect;
	[UIView animateWithDuration:0.3
					 animations:^{
						 view.frame = originalRect;
					 }
					 completion:^(BOOL finished) {
						 
					 }];
	return;
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	animation.values = @[@(1), @(1.2), @(0.01)];
	animation.keyTimes = @[@(0), @(0.4), @(1)];
	animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	animation.duration = 0.35;
	animation.delegate = self;
	//	[animation setValue:completion forKey:@"handler"];
	[view.layer addAnimation:animation forKey:@"bounce"];
	
	view.transform = CGAffineTransformMakeScale(0.01, 0.01);
	*/
}

- (void)animateFriendView:(UIView *)view  {
	
	[self showMenu];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, view);
	
	[UIView animateWithDuration:0.5
						  delay:0.1
						options: UIViewAnimationCurveEaseOut
					 animations:^
	 {
		 CGRect frame = view.frame;
		 frame.origin.y = view.frame.origin.y;
		 if (self.headerMapView.friendMapViewButton.isToggled == NO) {
			 frame.origin.y -= frame.size.height;
		 }
		 else {
			 frame.origin.y += frame.size.height;
		 }
		 view.frame = frame;
	 }
					 completion:^(BOOL finished)
	 {
		 NSLog(@"Completed");
		 
	 }];
}

#pragma mark - LMSHeaderMapViewDelegate

- (void)didToggleStickerButton:(id)sender {
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.mapView.stickerSelectionCollectionView);
	[self animateStickerView:self.stickerListContainer];
/*
	[self animateView:self.mapView withMargin:120 andDirection:NO];
	[self animateView:self.headerMapView withMargin:50 andDirection:YES];

*/
//	[self animateView:self.mapView withMargin:200 andDirection:NO];
//	[self animateView:self.headerMapView withMargin:50 andDirection:YES];

	//	[self animateView:self.headerMapView];
	
}

- (void)didToggleFriendButton:(id)sender {
	//INFO: test for fun
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.mapView);
	[self animateFriendView:self.friendListContainer];//.mapView.stickerSelectionCollectionView];
}

@end
