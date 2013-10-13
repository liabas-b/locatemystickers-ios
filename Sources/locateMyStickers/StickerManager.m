//
//  StickersManager.m
//  LMS
//
//  Created by Adrien Guffens on 4/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerManager.h"
#import "StickerRecord.h"
#import "StickerRecord+Manager.h"
#import "AFJSONRequestOperation.h"

#import "NSDictionary+QueryString.h"
#import "JsonTools.h"
#import "AppDelegate.h"

@interface StickerManager ()

@end

@implementation StickerManager

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
											  nil];
	
	[self addStickerRecordWithDictionary:stickerDictionary];
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


@end
