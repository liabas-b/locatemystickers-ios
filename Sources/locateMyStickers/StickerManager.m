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

#import "NSDictionary+QueryString.h"
#import "JsonTools.h"
#import "AppDelegate.h"

@interface StickerManager ()

@end

@implementation StickerManager

#pragma mark- check

- (BOOL)stickerAlreadyExistOnPhoneWithCode:(NSString *)code {
	//findAllSortedByProperty:@"code" ascending:YES];
	StickerRecord *stickerRecord = [StickerRecord findFirstByAttribute:@"code" withValue:code];
	[stickerRecord debug];
	return stickerRecord != nil;//[StickerRecord stickerIsAlreadyAddedWithCode:code managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
}

- (BOOL)stickerAlreadyExistOnPhone:(StickerRecord *)stickerRecord {
	
	return [StickerRecord stickerIsAlreadyAddedWithCode:stickerRecord.code];
}

- (void)stickerAlreadyExistOnWebServiceWithCode:(NSString *)code {
#warning TO implement
	NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  code, @"sticker[code]",
											  nil];
	
	[self stickerAlreadyExistOnWebServiceWithDictionary:stickerDictionary];
}

- (void)stickerAlreadyExistOnWebServiceWithDictionary:(NSDictionary *)dictionary {
	NSString *route = [NSString stringWithFormat:@"stickers/%@", [dictionary objectForKey:@"sticker[code]"]];
	
	NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	//[request setHTTPBody:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPMethod:@"GET"];
	
	NSLog(@"%s Request = %@", __PRETTY_FUNCTION__, [request description]);
	NSData *data = [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"%s BODY = %@", __PRETTY_FUNCTION__, dataString);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveStickerAlreadyExistOnWebServiceResponseWithData:data];
	}];
	
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
	NSLog(@"%s addMyPhone !!!", __PRETTY_FUNCTION__);
	
#warning TO implement
	
	{
		
		NSString *route = @"stickers";
		NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
		
		NSLog(@"%s Request = %@", __PRETTY_FUNCTION__, [request description]);
		
		[request setHTTPMethod:@"POST"];
		
		[request setHTTPBody:[[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
		NSData *data = [[dictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s BODY = %@", __PRETTY_FUNCTION__, dataString);
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[self didReceiveAddStickerRecordResponseWithData:data];
		}];
	}
}

- (void)addStickerRecord:(StickerRecord *)stickerRecord {
	[stickerRecord debug];
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
	NSLog(@"%s removePhone !!!", __PRETTY_FUNCTION__);
	
#warning TO implement
	/*NSMutableDictionary *stickerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											  code, @"sticker[code]",
											  nil];*/
	{
		NSString *route = [NSString stringWithFormat:@"stickers/%@", code];
		NSMutableURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
		
		NSLog(@"%s request = %@", __PRETTY_FUNCTION__, [request description]);
		
		[request setHTTPMethod:@"DELETE"];
		/*
		[request setHTTPBody:[[stickerDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
		NSData *data = [[stickerDictionary stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding];
		
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s BODY = %@", __PRETTY_FUNCTION__, dataString);
		*/
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[self didReceiveRemoveStickerRecordResponseWithData:data];
		}];
	}
}

- (void)removeStickerRecord:(StickerRecord *)stickerRecord {
	[self removeStickerRecordWithCode:stickerRecord.code != nil ? stickerRecord.code : [NSString stringWithFormat:@"%@", stickerRecord.stickerId]];
}

#pragma mark - handler

- (void)didReceiveStickerAlreadyExistOnWebServiceResponseWithData:(NSData *)data {
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s ------ <%@>", __PRETTY_FUNCTION__, dataString);
	}
	else
		NSLog(@"%s BAD", __PRETTY_FUNCTION__);
	
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if ([dataString length] >= 3 && [dataString length] >= 4) {
			if ([dataString boolValue] == YES) {
				//TODO: notify sitcker already exist
				NSLog(@"%s notify sitcker already exist", __PRETTY_FUNCTION__);
				[[NSNotificationCenter defaultCenter] postNotificationName:keyStickerAlreadyExistOnWebService object:[NSNumber numberWithBool:YES]];
			}
			else {
				//TODO: notify sitcker not exist on web service
				NSLog(@"%s notify sitcker not exist on web service", __PRETTY_FUNCTION__);
				[[NSNotificationCenter defaultCenter] postNotificationName:keyStickerAlreadyExistOnWebService object:[NSNumber numberWithBool:NO]];
			}
		}
		else //IF sticker already exist --> u get the sticker
		{
#warning TO implement
			NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
			NSLog(@"%s - %@ ---- WARNING NOT IMPLEMENTED", __PRETTY_FUNCTION__, dataDictionary);
			if (dataDictionary != nil) {
				//StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dataDictionary managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
				//[stickerRecord debug];
				
				//TODO: notify sticker remove
				
				//self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
//				[[AppDelegate appDelegate] saveContext];
			}
		}
	}
}

- (void)didReceiveAddStickerRecordResponseWithData:(NSData *)data {
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s ------ <%@>", __PRETTY_FUNCTION__, dataString);
	}
	else
		NSLog(@"%s BAD", __PRETTY_FUNCTION__);
	
	
	
	if (data) {
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		NSLog(@"%s - %@", __PRETTY_FUNCTION__, dataDictionary);
		if (dataDictionary != nil && [dataDictionary count] > 1) {
			StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dataDictionary];
			
			[stickerRecord debug];
			
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
			
			//TODO: notify sticker added
			[[NSNotificationCenter defaultCenter] postNotificationName:keyAddStickerRecord object:stickerRecord];
			
			//self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			//INFO: don't know
//			[[AppDelegate appDelegate] saveContext];
		}
	}
	
}

- (void)didReceiveRemoveStickerRecordResponseWithData:(NSData *)data {
#warning may be useless

	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%s ------ <%@>", __PRETTY_FUNCTION__, dataString);
	}
	else
		NSLog(@"%s BAD", __PRETTY_FUNCTION__);
	
	
	if (data) {
		#warning MAY be NOT IMPLEMENTED
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		NSLog(@"%s - %@ WARNING NOT IMPLEMENTED", __PRETTY_FUNCTION__, dataDictionary);
		if (dataDictionary != nil) {
			//StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dataDictionary managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
			//[stickerRecord debug];
			
			//TODO: notify sticker remove
			
			//self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
//			[[AppDelegate appDelegate] saveContext];
		}
	}
	
}

@end
