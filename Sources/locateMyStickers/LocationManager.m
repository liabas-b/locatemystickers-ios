//
//  ABViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isUpdatingLocation;

@end

@implementation LocationManager

- (id)init
{
    if (self = [super init]) {
        self.measurementArray = [NSMutableArray new];
    }
	
    return self;
}

- (void)setup
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
	
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.isUpdatingLocation = NO;
}

- (void)start
{
    if (self.isUpdatingLocation == YES)
        return;
	
    if ([self isLocationServiceAvailable] == NO)
        return;
	
	[self.locationManager startUpdatingLocation];
    
    self.isUpdatingLocation = YES;
}

- (void)stop
{
    if (self.isUpdatingLocation == NO)
        return;
	
    self.isUpdatingLocation = NO;
	
    if ([self isLocationServiceAvailable] == NO)
        return;
	
	[self.locationManager stopUpdatingLocation];
}

- (void)reset
{
    [self stop];
	
    [self.measurementArray removeAllObjects];
}

- (BOOL)isLocationServiceAvailable
{
#warning check langage
	
    if ([CLLocationManager locationServicesEnabled] == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
	
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Not Authorized" message:@"You currently do not authorize this app to use the location service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
	
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	BOOL isInBackground = NO;
	
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
	
	//TODO: check more
    for (CLLocation* location in locations) {
#ifdef DEBUG
		NSLog(@"<%@>", location);
#endif
        NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
        if (locationAge > 5.0) return; //the location reading is too old
		
        // test that the horizontal accuracy does not indicate an invalid measurement
        if (location.horizontalAccuracy < 0) return;
		
		/*
		 NSInteger count = [self.measurementArray count];
		 [self willChange:NSKeyValueChangeInsertion
         valuesAtIndexes:[NSIndexSet indexSetWithIndex:count] forKey: @"measurementArray"];
		 [self.measurementArray insertObject:location atIndex:count];
		 [self didChange:NSKeyValueChangeInsertion
         valuesAtIndexes:[NSIndexSet indexSetWithIndex:count] forKey: @"measurementArray"];
		*/
		
    }
	if (isInBackground) {
		[self doUpdate];
		//
	}
}

- (void) doUpdate
{
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		[self beginBackgroundUpdateTask];
#ifdef DEBUG
		NSLog(@"doing Update");
#endif
		NSURLResponse *response = nil;
		NSError  *error = nil;
		
		//NSData * responseData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
		
		// Do something with the result
		
		[self endBackgroundUpdateTask];
	});
}

- (void) beginBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void) endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
@end
