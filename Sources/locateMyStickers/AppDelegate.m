//
//  AppDelegate.m
//  locateMyStickers
//
//  Created by Adrien Guffens on 2/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AppDelegate.h"

#import "OptionsRecord.h"
#import "OptionsRecord+Manager.h"

#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

#import "NSDictionary+QueryString.h"

#import "JsonTools.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@property(nonatomic, assign) BOOL isFirstLaunch;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self UIAppearances];
	[self cleanUpCach];
	
	

	
	//TODO: finish to implement
	[self commonLauchInitialization:launchOptions];
	
    return YES;
}

- (void)commonLauchInitialization:(NSDictionary *)launchOptions
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		//INFo: start loacation manager
		//INFO: init database
		[self managedObjectContext];
		
		/*
		if ([[OptionsRecord optionsRecordsInManagedObjectContext:self.managedObjectContext] count] == 0) {
			self.optionsRecord = [OptionsRecord addUpdateOptionsWithDictionary:nil managedObjectContext:self.managedObjectContext];
		}
		else {
			self.optionsRecord = [[OptionsRecord optionsRecordsInManagedObjectContext:self.managedObjectContext] lastObject];
		}
		*/
		
		
		if (self.isFirstLaunch == YES) {
			[self performSelectorOnMainThread:@selector(populateDefaultStore) withObject:nil waitUntilDone:NO];
		}
		else {
			self.optionsRecord = [[OptionsRecord optionsRecordsInManagedObjectContext:self.managedObjectContext] lastObject];
		}
		
		self.locationManager = [LocationManager new];
		[self.locationManager setup];
		
//		self.sessionManager = [[SessionManager alloc] initWithHostName:@"http://192.168.1.103:3000"];
		self.sessionManager = [[SessionManager alloc] initWithHostName:@"http://web-service.locatemystickers.com"];
		
		self.connectionManager = [ConnectionManager new];

	});
}

- (void)populateDefaultStore {
	//INFO: populate if needed
	
	
	self.optionsRecord = [OptionsRecord addUpdateOptionsWithDictionary:nil managedObjectContext:self.managedObjectContext];
	self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
	self.optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:YES];
	self.optionsRecord.idOption = [NSNumber numberWithInt:0];
	/*
	NSDictionary *stickerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"My Phone", @"name",
									   @"0", @"id",
									   [[NSDate date] description], @"created_at",
									   [[NSDate date] description], @"updated_at",
									   @"1", @"is_active",
									   @"0", @"sticker_type_id",
									   nil];
	StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:stickerDictionary managedObjectContext:self.managedObjectContext];
	*/
	[self saveContext];
	/*
	 NSError *error;
	 if (![self.managedObjectContext save:&error])
	 NSLog(@"Error saving !! -> %@", error);
	 [self saveContext];
	 */
}

- (void)addMyPhone {
	NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  @"3", @"user_id",
//											  @"", @"sticker[id]",
											  @"My Phone", @"sticker[name]",
//											  [[NSDate date] description], @"sticker[created_at]",
//											  [[NSDate date] description], @"sticker[updated_at]",
//											  @"1", @"sticker[is_active]",
											  @"2", @"sticker[sticker_type_id]",
											  nil];

	
	{
		NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
		NSString *requestString = [NSString stringWithFormat:@"%@/users/3/stickers.json", hostName];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
		
		NSLog(@"requestString = %@", requestString);
		
		[request setHTTPMethod:@"POST"];
//		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

		
		[request setHTTPBody:[[stickerDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
		NSData *data = [[stickerDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
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
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dataDictionary managedObjectContext:self.managedObjectContext];
		[stickerRecord debug];
		self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
		[self saveContext];
	}
	
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	
	//INFO: check if is tracking
	//if (self.sessionManager.session isTracking)
	{
		//		[self.locationManager stopMonitoringSignificantLocationChanges];
		//		[self.locationManager startUpdatingLocation];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)cleanUpCach {
	/*
	 NSError *error;
	 NSURL *url = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"activityList"];
	 
	 [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
	 
	 if (error) {
	 NSLog(@"ABAppDelegate: No cach to clean");
	 }
	 else
	 NSLog(@"ABAppDelegate: Cach clean");
	 */
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LmsModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"LmsModel.sqlite"];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:[storeURL path]]) {
		self.isFirstLaunch = YES;
	}
	else {
		self.isFirstLaunch = NO;
	}
	
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Tools

+ (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

+ (UIStoryboard *)mainStoryBoard {
	UIStoryboard *mainStoryboard = nil;
	if ([AppDelegate deviceIsIpad]) {
		//TODO: the same with ipad
		if ([AppDelegate deviceIsIO6]) {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];//6
		} else {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad_iOS5" bundle:nil];//5
		}
		
	}
	else {
		if ([AppDelegate deviceIsIO6]) {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];//6
		} else {
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone_iOS5" bundle:nil];//5
		}
	}
	return mainStoryboard;
}

+ (BOOL)deviceIsIpad {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		return YES;
	}
	return NO;
}

+ (BOOL)deviceIsIO6 {
	return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0");
}

#pragma mark - UIAppearances

-(void)UIAppearances {
	
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
		UIImage *navBarImage = [UIImage imageNamed:@"header"];//barre320x44
		[[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
		
		//[[UIToolbar appearance] setColor:[UIColor redColor]];//setBackgroundImage:navBarImage];
		
		UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
		[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
		//INFO: Change the appearance of other navigation button
		UIImage *barButtonImage = [[UIImage imageNamed:@"redNormalButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
		[[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
    }
    else {
        //INFO: iOS 4.whatever and below
        //[self.tabBarController.tabBar insertSubview:imageView atIndex:0];
		
    }
	
	//INFO: set tabBar
	
	UIImage *tabBarBackground = [UIImage imageNamed:@"tabBar"];
	
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
	
	//[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]];
	
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
}

@end
