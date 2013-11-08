//
//  AnalyticsManager.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "AnalyticsManager.h"
#import "AppParameters.h"

#import "Parameters.h"
#import "NetworkKeys.h"

@implementation AnalyticsManager

- (id)init {
	self = [super init];
	if (self) {
		// Optional: automatically send uncaught exceptions to Google Analytics.
		[GAI sharedInstance].trackUncaughtExceptions = YES;
		// Optional: set debug to YES for extra debugging information.
		//[GAI sharedInstance].debug = YES;
		// Get a new tracker.
		id<GAITracker> newTracker = [[GAI sharedInstance] trackerWithTrackingId:[AppParameters defaultParameters].parameters.networkKeys.googleAnalyticsApiKey];
		// Set the new tracker as the default tracker, globally.
		[GAI sharedInstance].defaultTracker = newTracker;
//		[[GAI sharedInstance].defaultTracker setAnonymize:YES];
	}
	return self;
}

@end
