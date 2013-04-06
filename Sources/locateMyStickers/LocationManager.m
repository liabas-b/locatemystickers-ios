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
		/*
        self.measurementArray = [NSMutableArray new];
		NSError *error;
		
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocationRecord"
												  inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
		[fetchRequest setEntity:entity];
		[fetchRequest setReturnsObjectsAsFaults:NO];
		
		NSArray *fetchedObjects = [[AppDelegate appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
		*/
		self.measurementArray = [[NSMutableArray alloc] initWithArray:[LocationRecord locationRecordsInManagedObjectContext:[AppDelegate appDelegate].managedObjectContext]];
		//[[NSMutableArray alloc] initWithArray:fetchedObjects];
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
    if ([CLLocationManager locationServicesEnabled] == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
		
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = NO;
		[[AppDelegate appDelegate] saveContext];
//		return NO;
    }
    else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Not Authorized" message:@"You currently do not authorize this app to use the location service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
		
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = NO;
		[[AppDelegate appDelegate] saveContext];
//		return NO;
    }
	//MAY be set to YES
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
		LocationRecord *locationRecord = [LocationRecord addUpdatelocationWithDictionary:nil managedObjectContext:[AppDelegate appDelegate].managedObjectContext];//[NSEntityDescription insertNewObjectForEntityForName:@"LocationRecord" inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
		
		locationRecord.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
		locationRecord.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
		locationRecord.createdAt = [NSDate date];
		locationRecord.updatedAt = [NSDate date];
		//locationRecord.idLocation = [NSNumber numberWithInt:idLocation];


		if (![[AppDelegate appDelegate].managedObjectContext save:&error])
			NSLog(@"Saving error: %@", error);
		
		//[self.measurementArray addObject:locationRecord];
		
		[self addLocation:locationRecord];
		 
		
    }
	if (isInBackground) {
		[self doUpdate];
		//
	}
}


- (void)addLocation:(LocationRecord *)locationRecord {
	NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  @"3", @"user_id",
											  [NSString stringWithFormat:@"%@", locationRecord.latitude] , @"location[latitude]",
											  [NSString stringWithFormat:@"%@", locationRecord.latitude] , @"location[longitude]",
											  nil];
	
	
	{
		NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
		NSString *requestString = [NSString stringWithFormat:@"%@/users/3/stickers/67/locations.json", hostName];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
		
		NSLog(@"requestString = %@", requestString);
		
		[request setHTTPMethod:@"POST"];
		//		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		//		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		
		
		[request setHTTPBody:[[locationDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
		NSData *data = [[locationDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"BODY = %@", dataString);
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[self didReceiveData:data];
		}];
		//	StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:stickerDictionary managedObjectContext:self.managedObjectContext];
		
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
		NSLog(@"%@", dataDictionary);
		LocationRecord *locationRecord = [LocationRecord addUpdatelocationWithDictionary:dataDictionary managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
		[locationRecord debug];

		[[AppDelegate appDelegate] saveContext];
		
		NSInteger count = [self.measurementArray count];
		[self willChange:NSKeyValueChangeInsertion
         valuesAtIndexes:[NSIndexSet indexSetWithIndex:count] forKey: @"measurementArray"];
		[self.measurementArray insertObject:locationRecord atIndex:count];
		[self didChange:NSKeyValueChangeInsertion
		valuesAtIndexes:[NSIndexSet indexSetWithIndex:count] forKey: @"measurementArray"];

	}
	
}



- (void)doUpdate
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

- (void)beginBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
@end
