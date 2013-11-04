//
//  AppDelegate.m
//  locateMyStickers
//
//  Created by Adrien Guffens on 2/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AppDelegate.h"

#import "StickerAddingTableViewController.h"

#import "OptionsRecord.h"
#import "OptionsRecord+Manager.h"

#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

#import "NSDictionary+QueryString.h"
#import "CryptographyTools.h"

#import "UIFont+AppFont.h"


#import "JsonTools.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@property(nonatomic, assign) BOOL isFirstLaunch;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.mainColor = [UIColor colorWithRed:142.0/255.0 green:20.0/255.0 blue:45.0/255.0 alpha:1.0];//[UIColor colorWithRed:172.0/255.0 green:10.0/255.0 blue:45.0/255.0 alpha:1.0]
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
		
		[MagicalRecord setupCoreDataStackWithStoreNamed:@"LmsModel"];
		
		self.optionsRecord = [[OptionsRecord findAll] lastObject];
		if (self.optionsRecord == nil) {
			self.optionsRecord = [OptionsRecord createEntity];
			
			self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
			self.optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:YES];
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
			
		}
		self.stickerManager = [StickersManager new];
		
		self.locationManager = [LocationManager new];
		[self.locationManager setup];
		
		//		self.sessionManager = [[SessionManager alloc] initWithHostName:@"http://192.168.1.2:3000"];
		//		self.sessionManager = [[SessionManager alloc] initWithHostName:@"http://192.168.1.2:3000"];
		//		self.sessionManager = [[SessionManager alloc] initWithHostName:@"http://web-service.locatemystickers.com"];
		self.sessionManager = [[SessionManager alloc] initWithHostName:@"http://locatemystickers-dev.herokuapp.com"];
		
		self.connectionManager = [ConnectionManager new];
		
		self.websocketManager = [[WebSocketManager alloc] initWithHostName:@"ws://12.12.12.7:4242"];
//		self.websocketManager = [[WebSocketManager alloc] initWithHostName:@"ws://localhost:3000"];
//		self.websocketManager = [[WebSocketManager alloc] initWithHostName:@"http://pousse-lms.heroku-app.com"];
	});
}

- (void)populateDefaultStore {
	//INFO: populate if needed
	
	self.optionsRecord = [OptionsRecord createEntity];
	
	[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
		
		OptionsRecord *optionsRecord = [self.optionsRecord MR_inContext:localContext];
		
		optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:YES];
		
	} completion:^{
		self.optionsRecord = [[OptionsRecord findAll] lastObject];
	}];
}

+ (NSMutableURLRequest *)requestForCurrentUserWithRoute:(NSString *)route {
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	int currentUserId = 1;
	
	NSString *requestString = nil;
	if (route != nil) {
		requestString = [NSString stringWithFormat:@"%@/users/%d/%@.json", hostName, currentUserId, route];//stickers/67/locations
	}
	else {
		requestString = [NSString stringWithFormat:@"%@/users/%d.json", hostName, currentUserId];
	}
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	return request;
}

+ (NSMutableURLRequest *)requestForCurrentHostWithRoute:(NSString *)route {
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	
	NSString *requestString = nil;
	if (route != nil) {
		requestString = [NSString stringWithFormat:@"%@/%@", hostName, route];
	}
	else
		requestString = [NSString stringWithFormat:@"%@/", hostName];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	return request;
}

+ (NSMutableURLRequest *)requestForCurrentStickersHost {
	
	NSString *requestString = @"http://stickersserver.herokuapp.com/locations.json";
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
	//	[request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
	
	return request;
}

#pragma mark - Unique ID

+ (NSString *)identifierForCurrentUser {
	NSString *identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	
	NSString *identifierFinal = [NSString stringWithFormat:@"%@:%@", identifierForVendor, [AppDelegate appDelegate].sessionManager.session.login];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, identifierFinal);
	NSString *encodedIdentifier = [CryptographyTools stringToMD5:identifierFinal];
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, encodedIdentifier);
	
	return encodedIdentifier;
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
	//		[self.locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//#pragma mark - Tools

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

#pragma mark - sticker Adding

- (void)stickerAdding:(StickerRecord *)stickerRecord {
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	StickerAddingTableViewController *stickerAddingTableViewController  = (StickerAddingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"stickerAdding"];
	
	stickerAddingTableViewController.stickerRecord = stickerRecord;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:stickerAddingTableViewController];
	[self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
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
			mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_2_iPhone" bundle:nil];//6
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

- (void)UIAppearances {
	
	float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
    if (systemVersion > 4.9 && systemVersion < 7.0) {
		
		NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, [UIFont navBarFont], NSFontAttributeName, nil];
		[[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
		
		//
		UIImage *navBarImage = [UIImage imageNamed:@"lms-navigation-bar@2x.png"];
		[[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
		
		//INFO: Back button
		UIImage *backButtonImage = [[UIImage imageNamed:@"redBackButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
		[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
		//INFO: Default button
		UIImage *barButtonImage = [[UIImage imageNamed:@"redNormalButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
		[[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
	}
	else if (systemVersion >= 7.0) {
		
		[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
		[[UINavigationBar appearance] setBarStyle:UIStatusBarStyleLightContent];
		
		NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, [UIFont navBarFont], NSFontAttributeName, nil];
		
		[[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
		
		//[[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
		
		UIImage *backgroundImage = [AppDelegate imageWithColor:self.mainColor];
		[[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
	}
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

@end
