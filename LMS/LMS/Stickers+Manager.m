//
//  Stickers+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Stickers+Manager.h"
#import "AppDelegate.h"

@implementation Stickers (Manager)

- (void)updateWithUser:(User *)user andBlock:(StickersManagerHandler)completion {
	
	LMSAPIManager *apiManager = ((AppDelegate *)[AppDelegate appDelegate]).apiManager;
	
	NSString *route = [NSString stringWithFormat:@"users/%d/stickers.json", user.id];
	[apiManager GET:route parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"JSON: %@", [responseObject objectAtIndex:0]);
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:responseObject, @"stickers", nil];
		NSError *error;
		Stickers *stickers = [[Stickers alloc] initWithDictionary:dic error:&error];
		DLog(@"error: %@", error);
		DLog(@"Stickers: %@", stickers);
		completion(stickers);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Error: %@", error);
		completion(nil);
	}];
	
}


@end
