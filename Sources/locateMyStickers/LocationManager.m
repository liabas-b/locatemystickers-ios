//
//  ABViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LocationManager.h"

#import "OptionsRecord+Manager.h"

#import "LocationRecord.h"
#import "LocationRecord+Manager.h"

#import "NSString+QueryString.h"
#import "NSDictionary+QueryString.h"

#import "StickerManager.h"

#import "JsonTools.h"

#import "AppDelegate.h"

NSString* const keyPathMeasurementArray = @"measurementArray";

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isUpdatingLocation;

@end

@implementation LocationManager

- (id)init
{
    if (self = [super init]) {
		self.measurementArray = [[NSMutableArray alloc] initWithArray:[LocationRecord findAll]];//[LocationRecord locationRecordsInManagedObjectContext:[AppDelegate appDelegate].managedObjectContext]];
    }
	
    return self;
}

- (void)setup {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
	
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.isUpdatingLocation = NO;
}

- (void)start {
    if (self.isUpdatingLocation == YES)
        return;
	
    if ([self isLocationServiceAvailable] == NO)
        return;
	
	[self.locationManager startUpdatingLocation];
    
    self.isUpdatingLocation = YES;
	NSLog(@"%s startUpdatingLocation", __PRETTY_FUNCTION__);
}

- (void)startWithStickerTrackingId:(int)trackingStickerId {
	self.trackingStickerId = trackingStickerId;
	[self start];
}

- (void)stop {
    if (self.isUpdatingLocation == NO)
        return;
	
    self.isUpdatingLocation = NO;
	
    if ([self isLocationServiceAvailable] == NO)
        return;
	
	[self.locationManager stopUpdatingLocation];
	NSLog(@"%s stopUpdatingLocation", __PRETTY_FUNCTION__);
}

- (void)reset {
    [self stop];
	
    [self.measurementArray removeAllObjects];
}

- (BOOL)isLocationServiceAvailable {
    if ([CLLocationManager locationServicesEnabled] == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
		/*
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = NO;
		[[AppDelegate appDelegate] saveContext];
		 */
		//		return NO;
    }
    else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Not Authorized" message:@"You currently do not authorize this app to use the location service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
		/*
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = NO;
		[[AppDelegate appDelegate] saveContext];
		 */
		//		return NO;
    }
	//MAY be set to YES
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
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
		
		//TODO: add location to the web service and add it to DB
		
		/*
		 int idLocation = 0;
		 if ([self.measurementArray count] > 0) {
		 idLocation = [((LocationRecord*)[self.measurementArray lastObject]).idLocation intValue] + 1;
		 }
		 else {
		 idLocation = 0;
		 }
		 */
		//LocationRecord *locationRecord = [LocationRecord new];
		
		//		[self.measurementArray addObject:locationRecord];
		
		NSError *error;
		LocationRecord *locationRecord = [LocationRecord createEntity];//[LocationRecord addUpdatelocationWithDictionary:nil managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
		
		
		locationRecord.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
		locationRecord.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
		locationRecord.createdAt = [NSDate date];
		locationRecord.updatedAt = [NSDate date];

		 [[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		//locationRecord.idLocation = [NSNumber numberWithInt:idLocation];
		/*
		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
			
			LocationRecord *localLocationRecord = [locationRecord inContext:localContext];
			
			localLocationRecord.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
			localLocationRecord.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
			localLocationRecord.createdAt = [NSDate date];
			localLocationRecord.updatedAt = [NSDate date];
			
		} completion:^{
			NSLog(@"%s locationRecord saved", __PRETTY_FUNCTION__);
		}];
		*/
/*		if (![[AppDelegate appDelegate].managedObjectContext save:&error])
			NSLog(@"Saving error: %@", error);
		*/
		//[self.measurementArray addObject:locationRecord];
		
		[self performSelectorInBackground:@selector(addLocation:) withObject:locationRecord];
		//		[self addLocation:locationRecord];
		
		
    }
	if (isInBackground) {
		[self doUpdate];
		//
	}
}

- (void)addLocation:(LocationRecord *)locationRecord {
	NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											   @"3", @"id",
											   [NSString stringWithFormat:@"%@", locationRecord.latitude], @"location[latitude]",
											   [NSString stringWithFormat:@"%@", locationRecord.longitude], @"location[longitude]",
											   nil];//[NSString stringWithFormat:@"%d", self.trackingStickerId]
	
	
	{
		//INFO: stickerId of the tracked phone
		NSString *route = [NSString stringWithFormat:@"stickers/%d/locations", self.trackingStickerId];
		NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
		
		[request setHTTPMethod:@"POST"];		
		[request setHTTPBody:[[locationDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
		
		/*
		 NSData *data = [[locationDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		 NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		 NSLog(@"BODY = %@", dataString);
		 */
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[self didReceiveData:data];
		}];
	}
}

- (void)didReceiveData:(NSData *)data {
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		NSLog(@"dataDictionary: %@", dataDictionary);
		if (dataDictionary != nil) {
			LocationRecord *locationRecord = [LocationRecord addUpdatelocationWithDictionary:dataDictionary];
			[locationRecord debug];
			
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
			
			//INFO: insertion of location record in measurementArray and broadcast to subscribers
			NSInteger count = [self.measurementArray count];
			[self willChange:NSKeyValueChangeInsertion
			 valuesAtIndexes:[NSIndexSet indexSetWithIndex:count] forKey: @"measurementArray"];
			[self.measurementArray insertObject:locationRecord atIndex:count];
			[self didChange:NSKeyValueChangeInsertion
			valuesAtIndexes:[NSIndexSet indexSetWithIndex:count] forKey: @"measurementArray"];
		}
		
	}
	
}

#pragma mark - Background task

- (void)doUpdate
{
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		[self beginBackgroundUpdateTask];

		NSLog(@"doing Update");
		NSURLResponse *response = nil;
		NSError  *error = nil;
		
#warning could kill you
		//INFO: test
		int stickerId = [AppDelegate appDelegate].stickerManager ;

		
		NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
												   @"3", @"id",
												   @"42", @"location[latitude]",
												   @"42", @"location[longitude]",
												   nil];//[NSString stringWithFormat:@"%d", self.trackingStickerId]

		NSString *route = [NSString stringWithFormat:@"stickers/%d/locations", stickerId];
		NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
		
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:[[locationDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSData * responseData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:responseData];
		NSLog(@"dataDictionary: %@", dataDictionary);
		//INFO: making an alert
		
		[self notifyBackgroundWithMessage:@"Can speak in background with the Web Service"];
		
		
		// Do something with the result
		
		[self endBackgroundUpdateTask];
	});
}

- (void)beginBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		[self doUpdate];
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

#pragma mark - notify

- (void)notifyBackgroundWithMessage:(NSString *)message
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [NSDate date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = message;
    localNotif.alertAction = @"Attention";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication]presentLocalNotificationNow:localNotif];
}

@end
