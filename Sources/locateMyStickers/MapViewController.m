//
//  MapViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "MapViewController.h"
#import "UCTabBarItem.h"

#import "JsonTools.h"

#import "LocationRecord.h"
#import "StickerRecord.h"

#import "AppDelegate.h"
#import "LocationManager.h"


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
	
	[[AppDelegate appDelegate].locationManager addObserver:self forKeyPath:keyPathMeasurementArray options:NSKeyValueObservingOptionNew context:nil];
	
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//INFO: if sticker Record is set --> ask for all the location of the sticker
	//TODO: set the view with the stickerRecord
	if (self.stickerRecord != nil) {
		[self parseData];
	}
	
	//	self.locationsRecordList = [[NSMutableArray alloc] init];
	NSError *error;
	
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocationRecord"
											  inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	
	NSArray *fetchedObjects = [[AppDelegate appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
	self.locationsRecordList = [[NSMutableArray alloc] initWithArray:fetchedObjects];
	
	[self updateLocations];
	
}

#pragma mark - map

- (void)updateLocations {
	
	
	/*MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50, 50);
	 
	 if (region.center.longitude == -180.00000000)
	 return;
	 
	 
	 [self.mapView setRegion:region animated:NO];
	 */
	BOOL startExist = NO;
	for (LocationRecord *locationRecord in self.locationsRecordList) {
		CLLocationCoordinate2D startCoordinate;
		CLLocationCoordinate2D endCoordinate;
		
		if (startExist == NO) {
			startCoordinate = CLLocationCoordinate2DMake([locationRecord.longitude floatValue], [locationRecord.latitude floatValue]);
			startExist = YES;
		}
		else {
			endCoordinate = CLLocationCoordinate2DMake([locationRecord.longitude floatValue], [locationRecord.latitude floatValue]);;
			
			
			MKMapPoint points[2] = {MKMapPointForCoordinate(startCoordinate), MKMapPointForCoordinate(endCoordinate)};
			MKPolyline* polyline = [MKPolyline polylineWithPoints:points count:2];
			[self.mapView addOverlay:polyline];
			
			startCoordinate = endCoordinate;
			
		}
	}
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
		
        polylineView.lineWidth = 0;
        polylineView.strokeColor = [[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0] colorWithAlphaComponent:1];
        polylineView.lineJoin = kCGLineJoinRound;
        polylineView.lineCap = kCGLineCapRound;
		
        return polylineView;
    }
    else {
        return nil;
    }
}


#pragma mark - data parsing

- (void)parseData
{
	
    // TODO: Create an Operation Queue [OK]
	
	
	//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://web-service.locatemystickers.com/users/1/stickers/460/locations.json"]];
	NSString *requestString = [NSString stringWithFormat:@"http://192.168.1.100:3000/users/1/stickers/%@/locations.json", self.stickerRecord.codeAnnotation];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
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
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		//TODO: save file
		if (self.locationsRecordList) {
			[self.locationsRecordList removeAllObjects];
		}
		
		self.locationsRecordList = [[NSMutableArray alloc] init];
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		//NSLog(@"%@", [dataDictionary objectForKey:@"data"]);
		
		for (NSDictionary *item in [dataDictionary objectForKey:@"data"]) {
			//NSLog(@"%@", item);
			LocationRecord *locationRecord = [[LocationRecord alloc] initWithDictinary:item];
			[self.locationsRecordList addObject:locationRecord];
		}
		//TODO: update map with locationsRecordList
		[self updateLocations];
		
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:keyPathMeasurementArray]) {
        if ([change[NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeInsertion) {
			//TODO:[self.mapView addOverlay:polyline];
			
			//
            NSIndexSet* insertedIndexSet = change[NSKeyValueChangeIndexesKey];
			
            [insertedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
				
				NSLog(@"observeValueForKeyPath: %@", [AppDelegate appDelegate].locationManager.measurementArray[idx]);
				/*
				CLLocation* location = self.locationManager.measurementArray[idx];
				LocAnnotation* annotation = [[LocAnnotation alloc] initWithCoordinate:location.coordinate];
				[self.mapView addAnnotation:annotation];
*/
				 }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
