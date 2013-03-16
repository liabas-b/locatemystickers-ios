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
	[self parseData];

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
	
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://web-service.locatemystickers.com/users/1/stickers/460/locations.json"]];
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveData:data];
	}];
}

- (void)didReceiveData:(NSData *)data {
	//INFO: debug
	/*
	 if (data) {
	 NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	 NSLog(@"------ <%@>", dataString);
	 }
	 else
	 NSLog(@"BAD");
	 */
	
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

@end
