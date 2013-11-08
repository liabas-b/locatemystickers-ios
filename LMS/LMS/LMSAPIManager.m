//
//  LMSAPIManager.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSAPIManager.h"

@implementation LMSAPIManager

- (id)initWithBaseURLString:(NSString *)url {
	NSURL *baseURL = [NSURL URLWithString:url];
	self = [super initWithBaseURL:baseURL];
	if (self) {
		[self networkReachabilityHandler];
	}
	return self;
}

- (void)networkReachabilityHandler {
	NSOperationQueue *operationQueue = self.operationQueue;
	
	[self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		switch (status) {
			case AFNetworkReachabilityStatusReachableViaWWAN:
			case AFNetworkReachabilityStatusReachableViaWiFi:
				[operationQueue setSuspended:NO];
				break;
			case AFNetworkReachabilityStatusNotReachable:
			default:
				[operationQueue setSuspended:YES];
				break;
		}
	}];

}

@end
