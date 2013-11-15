//
//  AppDelegate.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "AppDelegate.h"
#import "LMSSticker.h"

@interface AppDelegate ()

@property(nonatomic, assign) BOOL isFirstLaunch;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	[self cleanUpCach];
	[self commonLauchInitialization:launchOptions];
	
    return YES;
}

- (void)commonLauchInitialization:(NSDictionary *)launchOptions {
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		self.appParameters = [AppParameters defaultParameters];
		self.appSession = [AppSession defaultSession];

		self.apiManager = [[LMSAPIManager alloc] initWithBaseURLString:self.appParameters.parameters.apiUrls.lmsApi];
//		self.websocketManager = [[WebSocketManager alloc] initWithHostName:self.appParameters.parameters.apiUrls.lmsLiveApi];
		self.pusherManager = [[PusherManager alloc] initWithAPIKey:self.appParameters.parameters.apiKeys.pusherApiKey];
		//		self.operationManager = [[OperationManager alloc] init];
		self.analyticsManager = [[AnalyticsManager alloc] init];
		
		[self UIAppearances];
	});
	 
}

#pragma mark - Unique ID

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

#pragma mark - Application's Documents directory



#pragma mark - Tools

+ (id)appDelegate {
    return [[UIApplication sharedApplication] delegate];
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
		
		UIImage *backgroundImage = [AppDelegate imageWithColor:[UIColor colorFromHexString:self.appParameters.parameters.color]];
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
