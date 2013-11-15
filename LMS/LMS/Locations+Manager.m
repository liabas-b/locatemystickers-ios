//
//  Locations+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Locations+Manager.h"
#import "AppDelegate.h"

@implementation Locations (Manager)

//-  (void)updateWithSticker:(LMSSticker *)sticker andBlock:(LocationsManagerHandler)completion {
//	[Locations updateWithSticker:sticker andBlock:completion];
//}

+ (void)updateWithSticker:(LMSSticker *)sticker andBlock:(LocationsManagerHandler)completion {
	
	LMSAPIManager *apiManager = ((AppDelegate *)[AppDelegate appDelegate]).apiManager;
	//stickers/38/locations.json
	NSString *route = [NSString stringWithFormat:@"users/%d/stickers/%d/locations.json", sticker.userId, sticker.id];
	[apiManager GET:route parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (responseObject == nil) {
			completion(nil);
		}
		DLog(@"JSON: %@", responseObject);
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:responseObject, @"locations", nil];
		NSError *error;
		Locations *locations = [[Locations alloc] initWithDictionary:dic error:&error];
		DLog(@"error: %@", error);
		DLog(@"Locations: %@", locations);
		completion(locations);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Error: %@", error);
		completion(nil);
	}];
	
}

@end
