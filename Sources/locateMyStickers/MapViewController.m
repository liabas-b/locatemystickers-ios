//
//  MapViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "MapViewController.h"

#import "LocationRecord.h"
#import "LocationRecord+Manager.h"

#import "StickerRecord.h"
#import "StickerRecord+Manager.h"



#import "LocAnnotation.h"
#import "LocationManager.h"

#import "AFJSONRequestOperation.h"

#import "UCTabBarItem.h"
#import "JsonTools.h"
#import "AppDelegate.h"

#import "UIViewController+Extension.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
	
	[self configureMenuLeftButtonWithBackButon:YES];
	self.title = @"Map";
	self.mapView.isDisplayingStickerList = YES;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
//	[self performSelectorInBackground:@selector(setupMap) withObject:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	[self setupMap];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	
	//[[AppDelegate appDelegate].locationManager removeObserver:self forKeyPath:keyPathMeasurementArray];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupMap {
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	[context setParentContext:[NSManagedObjectContext defaultContext]];
	NSManagedObjectContext *unused __attribute__((unused)) = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
	

	//INFO: update sticker list
	[[AppDelegate appDelegate].stickerManager getStickersRecordWithSuccess:^(NSMutableDictionary *JSON) {
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		for (NSDictionary *item in JSON) {
			StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:item];
		}
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		[self loadStickerList];

	} failure:^(NSURLRequest *request, NSError *erro, id JSON) {
		NSLog(@"%s | request: %@", __PRETTY_FUNCTION__, [request description]);
		NSLog(@"%s | erro: %@", __PRETTY_FUNCTION__, [erro description]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
	}];
	
	[self loadStickerList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"Map"
											imageSelected:@"world_black"
											andUnselected:@"world_white"];
}

- (void)loadStickerList {
	NSArray *stickerRecordList = [StickerRecord findAllSortedBy:@"createdAt" ascending:NO];
	NSLog(@"%s | stickerRecordList: %@", __PRETTY_FUNCTION__, stickerRecordList);
	
	[self.mapView loadStickerList:stickerRecordList];
}

#pragma mark - data parsing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:keyPathMeasurementArray]) {
        if ([change[NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeInsertion) {
			
			/*
			 NSIndexSet* insertedIndexSet = change[NSKeyValueChangeIndexesKey];
			 
			 [insertedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			 #warning TO CHECK
			 NSLog(@"observeValueForKeyPath: %@", [AppDelegate appDelegate].locationManager.measurementArray[idx]);
			 
			 CLLocation* location = [AppDelegate appDelegate].locationManager.measurementArray[idx];
			 LocAnnotation* annotation = [[LocAnnotation alloc] initWithCoordinate:location.coordinate];
			 [self.mapView addAnnotation:annotation];
			 
			 }];
			 */
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
