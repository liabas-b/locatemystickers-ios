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
#import "StickerRecord+Manager.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Main logic

- (void)configure {
	self.headerMapView.delegate = self;
	
	//	[self.headerMapView.stickerMapViewButton addTarget:self action:@selector(myEvent:) forControlEvents:UIControlEventTouchDown];
	
	[self loadStickerList];
//	[self animateView:self.view];//mapView.stickerSelectionCollectionView];
}

- (void)loadStickerList {
	NSArray *stickerRecordList = [StickerRecord findAllSortedBy:@"createdAt" ascending:NO];
	NSLog(@"%s | stickerRecordList: %@", __PRETTY_FUNCTION__, stickerRecordList);
	
	[self.mapView loadStickerList:stickerRecordList];
}

- (void)animateView:(UIView *)view  {
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, view);
	
	[UIView animateWithDuration:0.5
						  delay:0.1
						options: UIViewAnimationCurveEaseOut
					 animations:^
	 {
		 CGRect frame = view.frame;
		 frame.origin.y = 0;
		 frame.origin.x -= -100;
		 view.frame = frame;
	 }
					 completion:^(BOOL finished)
	 {
		 NSLog(@"Completed");
		 
	 }];
	
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
}

#pragma mark - LMSHeaderMapViewDelegate

- (void)didToggleStickerButton:(id)sender {
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.mapView.stickerSelectionCollectionView);
	[self animateView:self.stickerListContainer];
	
}

- (void)didToggleFriendButton:(id)sender {
	//INFO: test for fun
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.mapView);
	[self animateView:self.stickerListContainer];//.mapView.stickerSelectionCollectionView];
}

@end
