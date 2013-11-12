//
//  Friends+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 12/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Friends+Manager.h"
#import "AppDelegate.h"


@implementation Friends (Manager)

- (void)updateWithUser:(User *)user andBlock:(FriendsManagerHandler)completion {

	LMSAPIManager *apiManager = ((AppDelegate *)[AppDelegate appDelegate]).apiManager;
	
	NSString *route = [NSString stringWithFormat:@"users/%d/friends.json", user.id];
	[apiManager GET:route parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"JSON: %@", [responseObject objectAtIndex:0]);
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:responseObject, @"friends", nil];
		NSError *error;
		Friends *friends = [[Friends alloc] initWithDictionary:dic error:&error];
		DLog(@"error: %@", error);
		DLog(@"Friends: %@", friends);
		completion(friends);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Error: %@", error);
		completion(nil);
	}];

}

@end
