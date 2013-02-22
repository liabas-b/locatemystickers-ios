//
//  AppDelegate.m
//  locateMyStickers
//
//  Created by Adrien Guffens on 2/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AppDelegate.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	
	[self UIAppearances];
	[self cleanUpCach];
	
	self.locationManager = [LocationManager new];
    [self.locationManager setup];
	
	self.sessionManager = [SessionManager new];
	
	self.connectionManager = [ConnectionManager new];
	
    return YES;
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
		[self.locationManager stopMonitoringSignificantLocationChanges];
		[self.locationManager startUpdatingLocation];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)cleanUpCach {
	NSError *error;
	NSURL *url = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"activityList"];
	
	[[NSFileManager defaultManager] removeItemAtURL:url error:&error];
	
	if (error) {
		NSLog(@"ABAppDelegate: No cach to clean");
	}
	else
		NSLog(@"ABAppDelegate: Cach clean");
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
    //INFO: set the background of tab bar
	// UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
	
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
		UIImage *navBarImage = [UIImage imageNamed:@"header"];//barre320x44
		[[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
		
		UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];//button_back-tmp.png
		[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
		// Change the appearance of other navigation button
		UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
		[[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
		//INFO: test
		//UIImage *buttonImage = [[UIImage imageNamed:@"greyButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
		//[[UIButton appearance] setBackgroundImage:buttonImage];
		//setBackButtonBackgroundImage:buttonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		
		
		//UIImage* backButtonImage = [UIImage imageNamed:@"button_back-tmp.png"];
		//[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else {
        //INFO: iOS 4.whatever and below
        //[self.tabBarController.tabBar insertSubview:imageView atIndex:0];
		
    }
	
	//INFO: set tabBar
	//UIImage *tabBarBackground = [UIImage imageNamed:@"barre640x88blanc"];
	
	//UIImage *tabBarBackground = [UIImage imageNamed:@"tabbar"];
	//UIImage *tabBarBackground = [UIImage imageNamed:@"barre320x44"];
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
	
	//[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]];
	
	
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
}


@end
