//
//  User+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "User+Manager.h"
#import "AppDelegate.h"

@implementation User (Manager)

+ (User *)addUpdateWithDictionary:(NSDictionary *)dictionary {
#warning NOT IMPLEMENTED
	return nil;
}

+ (User *)addUpdateWithUser:(User *)user {
#warning NOT IMPLEMENTED
	//TODO: add user to db if does not exist / update the user
	
	return nil;
}

+ (User *)addUpdateWithJSON:(NSString *)JSON {
	NSError *error = nil;
	
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
	
	User *user = [[User alloc] initWithDictionary:json error:&error];
	
	//	user = [User addUpdateWithUser:user];
	
	return user;
}

#pragma mark - Update
//- (void)update:(void (^)(id object))completion  {
- (void)update:(UserManagerHandler)completion  {
	
	LMSAPIManager *apiManager = ((AppDelegate *)[AppDelegate appDelegate]).apiManager;
	NSString *route = [NSString stringWithFormat:@"users/%d.json", self.id];

	[apiManager GET:route parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"JSON: %@", responseObject);
		NSError *error;
		User *user = [[User alloc] initWithDictionary:responseObject error:&error];
		completion(user);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"Error: %@", error);
		completion(nil);
	}];
	
}

@end
