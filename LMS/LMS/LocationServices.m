//
//  LocationServices.m
//  Tenjoon
//
//  Created by Adrien Guffens on 11/02/14.
//  Copyright (c) 2014 Team3000. All rights reserved.
//

#import "LocationServices.h"

@implementation LocationServices

@synthesize locationManager, currentLocation;


+ (LocationServices *)defaultLocationServices {
    static LocationServices *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)startLocationServices:(LocationServicesCompletionHandler)completion {

	_completion = completion;
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	locationManager.distanceFilter = kCLDistanceFilterNone;

	NSString *message = @"";
	
	if ([CLLocationManager locationServicesEnabled]) {
		[locationManager startUpdatingLocation];
		message = @"startUpdatingLocation";
		
	} else {
		NSLog(@"Location services is not enabled");
		message = @"Location services is not enabled";
	}
}

- (void)stopLocationServices {
//	DLog(@"");
	[locationManager stopUpdatingLocation];
}

- (CLLocation *)location {
	CLLocation *location = [locationManager location];
	
	if (NO) {
		CLLocationCoordinate2D coordinate;

		coordinate = [location coordinate];
		
//		DLog(@"coord: longitude: %@ - latitude: %@", @(coordinate.longitude), @(coordinate.latitude));
	}
	
	return location;
}

- (void)locationString:(LocationServicesCompletionHandler)completion {
	CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
	[geoCoder reverseGeocodeLocation:[self location] completionHandler:^(NSArray *placemarks, NSError *error) {

		if (completion) {
			if (placemarks && [placemarks count]) {
				completion([placemarks firstObject]);
			} else {
				completion(nil);
			}
		}
    }];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//	DLog(@"");
	
	NSString *stringStatus;
	
	switch (status) {
		case kCLAuthorizationStatusAuthorized:
		{
			stringStatus = @"kCLAuthorizationStatusAuthorized";
		}
			break;
		case kCLAuthorizationStatusDenied:
		{

			stringStatus = @"kCLAuthorizationStatusDenied";
		}
			break;
		case kCLAuthorizationStatusRestricted:
		{
			stringStatus = @"kCLAuthorizationStatusRestricted";
		}
			break;
		case kCLAuthorizationStatusNotDetermined:
		{
			stringStatus = @"kCLAuthorizationStatusNotDetermined";
		}
			
		default:
			break;
	}
	
	self.completion(stringStatus);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//	DLog(@"locations: %@", locations);

//	NSString *message = [NSString stringWithFormat:@"locations: %@", locations];
	
//	DLog(@"%@", message);
	if (locations && [locations count]) {
		self.lastLocation = [locations lastObject];
	}
	
	if (self.updateCompletion) {
		self.updateCompletion(locations);
	}

}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[locationManager stopUpdatingLocation];

	
	NSString *message = [NSString stringWithFormat:@"Update failed with error: %@", error];
	
	DLog(@"%@", message);
}

@end
