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
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//TODO: Make it works
	//self.stickerRecord = [StickerRecord findFirstByAttribute:@"code" withValue:[AppDelegate identifierForCurrentUser]];

//	[self performSelectorInBackground:@selector(setupMap) withObject:nil];
	[self setupMap];
}

- (void)setupMap {
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	[context setParentContext:[NSManagedObjectContext defaultContext]];
	NSManagedObjectContext *unused __attribute__((unused)) = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
	
	
	NSArray *stickerRecordList = [StickerRecord findAllSortedBy:@"createdAt" ascending:NO];
	
	self.stickerRecord = [stickerRecordList firstObject];
//	[self updateLocationForSticker];
	
	
	NSLog(@"%s | stickerRecordList: %@", __PRETTY_FUNCTION__, stickerRecordList);
	self.mapView.isDisplayingStickerList = YES;
	[self.mapView loadStickerList:stickerRecordList];
	/*
	NSArray *array = [LocationRecord findAllSortedBy:@"updatedAt" ascending:NO inContext:[NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]]];
	NSLog(@"%s %@", __PRETTY_FUNCTION__, array);
	if ([array count] > 0) {
		self.mapView.locationsRecordList = [[NSMutableArray alloc] initWithArray:array];
		
		[self.mapView performSelectorOnMainThread:@selector(loadSelectedOptions) withObject:nil waitUntilDone:YES];
	}
	else {
		[self updateLocationForSticker];
	}
	 */
}
/*
- (void)updateLocationForSticker {
	if (self.stickerRecord == nil)
		return;
	
	NSString *route = [NSString stringWithFormat:@"stickers/%@/locations", self.stickerRecord.code];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

		NSLog(@"%s | Request: %@", __PRETTY_FUNCTION__, [request description]);
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);

		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			LocationRecord *locationRecord = [LocationRecord addUpdateWithDictionary:dic];
			NSLog(@" %s| locationRecord: %@", __PRETTY_FUNCTION__, locationRecord);
		}
		[self.mapView loadSticker:self.stickerRecord];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"%s | Request: %@", __PRETTY_FUNCTION__, [request description]);
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
	}];
	[operation start];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//[[AppDelegate appDelegate].locationManager removeObserver:self forKeyPath:keyPathMeasurementArray];
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

#pragma mark - data parsing
/*
- (void)parseData
{
	NSString *route = [NSString stringWithFormat:@"stickers/%@/locations", self.stickerRecord.stickerId];
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	NSLog(@"%s request: %@", __PRETTY_FUNCTION__, [request description]);
	
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveData:data];
	}];
}

- (void)didReceiveData:(NSData *)data {
	//INFO: debug
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s ------ <%@>", __PRETTY_FUNCTION__, dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		//TODO: save file
		if (self.mapView.locationsRecordList) {
			//[self.mapView.locationsRecordList removeAllObjects];
		}
		
		self.mapView.locationsRecordList = [[NSMutableArray alloc] init];
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		//NSLog(@"%@", [dataDictionary objectForKey:@"data"]);
		
		for (NSDictionary *item in [dataDictionary objectForKey:@"data"]) {
			//NSLog(@"%@", item);
			LocationRecord *locationRecord = [LocationRecord addUpdateWithDictionary:item];
			if (locationRecord)
				[self.mapView.locationsRecordList addObject:locationRecord];
		}
		//TODO: update map with locationsRecordList
		
#warning updating LOCATIONS
		//[self.mapView updateLocations];
		[self.mapView loadSelectedOptions];
	}
}
*/
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
