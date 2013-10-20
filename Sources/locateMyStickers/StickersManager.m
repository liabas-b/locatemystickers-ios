//
//  StickersManager.m
//  LMS
//
//  Created by Adrien Guffens on 4/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickersManager.h"
#import "StickerRecord.h"
#import "StickerRecord+Manager.h"
#import "AFJSONRequestOperation.h"

#import "NSDictionary+QueryString.h"
#import "JsonTools.h"
#import "AppDelegate.h"

#import "StickerConfigurationRecord.h"
#import "StickerConfigurationRecord+Manager.h"

@interface StickersManager ()

@end

@implementation StickersManager

#pragma mark- check

- (BOOL)stickerAlreadyExistOnPhoneWithCode:(NSString *)code {
	StickerRecord *stickerRecord = [StickerRecord findFirstByAttribute:@"code" withValue:code];

	return stickerRecord != nil;
}

- (BOOL)stickerAlreadyExistOnPhone:(StickerRecord *)stickerRecord {
	
	return [StickerRecord stickerIsAlreadyAddedWithCode:stickerRecord.code];
}

- (void)stickerAlreadyExistOnWebServiceWithCode:(NSString *)code {
	NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  code, @"sticker[code]",
											  nil];
	
	[self stickerAlreadyExistOnWebServiceWithDictionary:stickerDictionary];
}

- (void)stickerAlreadyExistOnWebServiceWithDictionary:(NSDictionary *)dictionary {
	NSString *route = [NSString stringWithFormat:@"stickers.json?search=%@&column=code", [dictionary objectForKey:@"sticker[code]"]];
	
	NSMutableURLRequest *request = [AppDelegate requestForCurrentHostWithRoute:route];
	
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s | request = %@", __PRETTY_FUNCTION__, [request description]);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, dictionary);
	
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		
		//TODO: check status code
		if ([JSON count] > 0)
			[[NSNotificationCenter defaultCenter] postNotificationName:keyStickerAlreadyExistOnWebService object:[NSNumber numberWithBool:YES]];
		else
			[[NSNotificationCenter defaultCenter] postNotificationName:keyStickerAlreadyExistOnWebService object:[NSNumber numberWithBool:NO]];
		
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
	}];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];

}

- (void)stickerAlreadyExistOnWebService:(StickerRecord *)stickerRecord {
	
#warning TO implement
	NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  stickerRecord.name, @"sticker[name]",
											  stickerRecord.code, @"sticker[code]",
											  stickerRecord.stickerTypeId, @"sticker[sticker_type_id]",
											  nil];
	
	[self stickerAlreadyExistOnWebServiceWithDictionary:stickerDictionary];
}

#pragma mark - Add

- (void)addStickerRecordWithDictionary:(NSDictionary *)dictionary {
	NSLog(@"%s | dictionary %@", __PRETTY_FUNCTION__, dictionary);
	
	NSString *route = @"stickers";
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
		
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef DEBUG
	{
		NSData *data = [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s | BODY = %@", __PRETTY_FUNCTION__, dataString);
	}
#endif

	
	NSLog(@"%s | request = %@", __PRETTY_FUNCTION__, [request description]);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]);

	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:JSON];
		
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		//INFO: notify sticker added
		[[NSNotificationCenter defaultCenter] postNotificationName:keyAddStickerRecord object:stickerRecord];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
	
}

- (void)addStickerRecord:(StickerRecord *)stickerRecord {
	NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  stickerRecord.code, @"sticker[code]",
											  stickerRecord.stickerTypeId, @"sticker[sticker_type_id]",
											  stickerRecord.name, @"sticker[name]",
											  stickerRecord.text, @"sticker[text]",
											  stickerRecord.stickerConfiguration.configurationId, @"sticker[sticker_configuration_id]",
											  nil];
	
	[self addStickerRecordWithDictionary:stickerDictionary];
}


///___

- (void)updateStickerRecordWithDictionary:(NSMutableDictionary *)dictionary {
	NSLog(@"%s | dictionary %@", __PRETTY_FUNCTION__, dictionary);
	
	NSString *route = [NSString stringWithFormat:@"stickers/%@/sticker_configurations/%@", [dictionary objectForKey:@"sticker_code"], [dictionary objectForKey:@"id"]];
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
	
#ifdef DEBUG
	{
		NSData *data = [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s | BODY = %@", __PRETTY_FUNCTION__, dataString);
	}
#endif
	
	
	NSLog(@"%s | request = %@", __PRETTY_FUNCTION__, [request description]);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]);
	
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		
		StickerRecord *sticker = [StickerRecord addUpdateStickerWithCode:JSON];
		
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		//INFO: notify sticker updated
		[[NSNotificationCenter defaultCenter] postNotificationName:keyUpdateStickerConfigurationRecord object:sticker];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
}

- (void)updateStickerRecord:(StickerRecord *)stickerRecord {
	NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  stickerRecord.code, @"sticker[code]",
											  stickerRecord.stickerTypeId, @"sticker[sticker_type_id]",
											  stickerRecord.name, @"sticker[name]",
											  stickerRecord.text, @"sticker[text]",
											  stickerRecord.stickerConfiguration.configurationId , @"sticker[sticker_configuration_id]",
											  nil];
	
	[self updateStickerRecordWithDictionary:stickerDictionary];
}

#pragma mark - Remove

- (void)removeStickerRecordWithCode:(NSString *)code {
	NSLog(@"%s remove stickerRecord with code: %@", __PRETTY_FUNCTION__, code);
	
	NSString *route = [NSString stringWithFormat:@"stickers/%@", code];
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	NSLog(@"%s | request = %@", __PRETTY_FUNCTION__, [request description]);
	
	[request setHTTPMethod:@"DELETE"];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

		NSLog(@"%s | Request: %@", __PRETTY_FUNCTION__, [request description]);
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		//TDO: check the answer
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

		NSLog(@"%s | Request: %@", __PRETTY_FUNCTION__, [request description]);
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		//TDO: check the answer
		
	}];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
}

- (void)removeStickerRecord:(StickerRecord *)stickerRecord {
	[self removeStickerRecordWithCode:stickerRecord.code != nil ? stickerRecord.code : [NSString stringWithFormat:@"%@", stickerRecord.stickerId]];
}


- (void)updateStickerRecordWithStickerRedord:(StickerRecord *)stickerRecord success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error))failure {
	NSString *requestString = [NSString stringWithFormat:@"stickers/%@", stickerRecord.stickerId];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:requestString];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		success(JSON);
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		failure(request, error);
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
}

- (void)getStickersRecordWithSuccess:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *erro, id JSON))failure {
	
	NSString *requestString = [NSString stringWithFormat:@"stickers"];
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:requestString];
	[request setHTTPMethod:@"GET"];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		success(JSON);
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		failure(request, error, JSON);
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
}

//

#pragma mark - Update Sticker Configuration


- (void)getStickerConfigurationRecordWithStickerRecord:(StickerRecord *)stickerRecord success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error))failure {
	
	NSString *route = [NSString stringWithFormat:@"stickers/%@/sticker_configurations", stickerRecord.stickerId];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"Result: %@", JSON);
		NSMutableArray *array = (NSMutableArray *)JSON;
		
		success([array firstObject]);
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		failure(request, error);
	}];
	[operation start];
}

- (void)getStickerConfigurationRecordWithStickerCode:(NSString *)stickerCode success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error))failure {

	NSString *route = [NSString stringWithFormat:@"stickers/%@/sticker_configurations", stickerCode];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"Result: %@", JSON);
		NSMutableArray *array = (NSMutableArray *)JSON;
		
		success([array firstObject]);
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		failure(request, error);
	}];
	[operation start];
}

#pragma mark - Update

- (void)updateStickerConfigurationRecordWithDictionary:(NSDictionary *)dictionary {
	NSLog(@"%s | dictionary %@", __PRETTY_FUNCTION__, dictionary);
	
	NSString *route = @"stickers";
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
	
#ifdef DEBUG
	{
		NSData *data = [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s | BODY = %@", __PRETTY_FUNCTION__, dataString);
	}
#endif
	
	
	NSLog(@"%s | request = %@", __PRETTY_FUNCTION__, [request description]);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]);
	
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		
		StickerConfigurationRecord *stickerConfigurationRecord = [StickerConfigurationRecord addUpdateWithDictionary:JSON];
		
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		//INFO: notify sticker updated
		[[NSNotificationCenter defaultCenter] postNotificationName:keyUpdateStickerConfigurationRecord object:stickerConfigurationRecord];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
	
}

- (void)updateStickerConfigurationRecord:(StickerConfigurationRecord *)stickerConfigurationRecord {
	NSMutableDictionary *stickerConfigurationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  stickerConfigurationRecord.activate, @"sticker_configuration[activate]",
											  stickerConfigurationRecord.frequencyUpdate, @"sticker_configuration[frequency_update]",
											  stickerConfigurationRecord.configurationId, @"sticker_configuration[id]",
											  stickerConfigurationRecord.stickerCode, @"sticker_configuration[sticker_code]",
											  nil];
	
	[self updateStickerConfigurationRecordWithDictionary:stickerConfigurationDictionary];
}

#pragma mark - Add

- (void)addStickerConfigurationRecordWithDictionary:(NSDictionary *)dictionary {
	NSLog(@"%s | dictionary %@", __PRETTY_FUNCTION__, dictionary);
	
	NSString *route = @"stickers";
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
	
#ifdef DEBUG
	{
		NSData *data = [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s | BODY = %@", __PRETTY_FUNCTION__, dataString);
	}
#endif
	
	
	NSLog(@"%s | request = %@", __PRETTY_FUNCTION__, [request description]);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]);
	
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		
		StickerConfigurationRecord *stickerConfigurationRecord = [StickerConfigurationRecord addUpdateWithDictionary:JSON];
		
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		//INFO: notify sticker updated
		[[NSNotificationCenter defaultCenter] postNotificationName:keyAddStickerConfigurationRecord object:stickerConfigurationRecord];

		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
	
}

- (void)addStickerConfigurationRecord:(StickerConfigurationRecord *)stickerConfigurationRecord {
	NSMutableDictionary *stickerConfigurationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
														   stickerConfigurationRecord.activate, @"sticker_configuration[activate]",
														   stickerConfigurationRecord.frequencyUpdate, @"sticker_configuration[frequency_update]",
														   stickerConfigurationRecord.stickerCode, @"sticker_configuration[sticker_code]",
														   nil];
	
	[self addStickerConfigurationRecordWithDictionary:stickerConfigurationDictionary];
}

@end
