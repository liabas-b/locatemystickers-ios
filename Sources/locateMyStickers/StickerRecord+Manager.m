//
//  StickerRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerRecord+Manager.h"
#import "StickerConfigurationRecord.h"
#import "StickerConfigurationRecord+Manager.h"
#import "ConventionTools.h"
#import "StickersManager.h"

#import "AppDelegate.h"

static NSString *entityName = @"StickerRecord";

@implementation StickerRecord (Manager)

+ (StickerRecord *)addUpdateStickerWithCode:(NSString *)code {//managedObjectContext:(NSManagedObjectContext *)moc {
	StickerRecord *stickerRecord = [StickerRecord findFirstByAttribute:@"code" withValue:code];
	
	if (stickerRecord == nil) {
		stickerRecord = [StickerRecord findFirstByAttribute:@"stickerId" withValue:code];
		if (stickerRecord == nil) {
			stickerRecord = [StickerRecord createEntity];
			
			stickerRecord.code = code;
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		}
	}
	return stickerRecord;
}

+ (StickerRecord *)addUpdateStickerWithDictionary:(NSDictionary *)dictionary {
	StickerRecord *stickerRecord = nil;
	
	if (dictionary == nil) {
		stickerRecord = [StickerRecord createEntity];
		return stickerRecord;
	}
	
	if ([dictionary objectForKey:@"code"] != [NSNull null]) {
		NSLog(@"%s %@", __PRETTY_FUNCTION__, [dictionary objectForKey:[dictionary objectForKey:@"code"]]);
		stickerRecord = [StickerRecord findFirstByAttribute:@"code" withValue:[dictionary objectForKey:@"code"]];
	}
	else if ([dictionary objectForKey:@"id"] != [NSNull null]) {
		stickerRecord = [StickerRecord findFirstByAttribute:@"stickerId" withValue:[dictionary objectForKey:@"id"]];
	}
	if (stickerRecord == nil) {
		stickerRecord = [StickerRecord createEntity];
	}
	
	stickerRecord.name = [dictionary objectForKey:@"name"];
	stickerRecord.code = [dictionary objectForKey:@"code"] != [NSNull null] ? [dictionary objectForKey:@"code"] : nil;
	stickerRecord.imageName = @"";
	stickerRecord.stickerId = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] intValue]];
	stickerRecord.createdAt = [ConventionTools getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	stickerRecord.updatedAt = [ConventionTools getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	//	stickerRecord.isActive = [NSNumber numberWithBool:[[dictionary objectForKey:@"is_active"] boolValue]];
	stickerRecord.stickerTypeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"sticker_type_id"] intValue]];
	stickerRecord.text = [dictionary objectForKey:@"text"] != [NSNull null] ? [dictionary objectForKey:@"text"] : nil;
	stickerRecord.color = [dictionary objectForKey:@"color"] != [NSNull null] ? [dictionary objectForKey:@"color"] : nil;
	//	stickerRecord.frenquencyUpdate = @([[dictionary objectForKey:@"frequency_update"] intValue]);
	stickerRecord.lastLocation = [dictionary objectForKey:@"last_location"] != [NSNull null] ? [dictionary objectForKey:@"last_location"] : nil;
	
	StickerConfigurationRecord *stickerConfigurationRecord = [StickerConfigurationRecord findFirstByAttribute:@"configurationId" withValue:stickerRecord.stickerConfigurationId];
	stickerRecord.stickerConfiguration = stickerConfigurationRecord;
	
	
	if (stickerConfigurationRecord == nil) {
		[[AppDelegate appDelegate].stickerManager getStickerConfigurationRecordWithStickerCode:stickerRecord.code success:^(NSMutableDictionary *JSON) {
			NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
			StickerConfigurationRecord *stickerConfigurationRecord = [StickerConfigurationRecord addUpdateWithDictionary:JSON];
			stickerRecord.stickerConfiguration = stickerConfigurationRecord;
			
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		} failure:^(NSURLRequest *request, NSError *error) {
			NSLog(@"%s | request: %@ - error: %@", __PRETTY_FUNCTION__, [request description], [error description]);
		}];
	}
	
	[[NSManagedObjectContext defaultContext] saveNestedContexts];
	
	return stickerRecord;
}

+ (BOOL)stickerIsAlreadyAddedWithCode:(NSString *)code {
	StickerRecord *stickerRecord = [StickerRecord findFirstByAttribute:@"code" withValue:code];
	
	return stickerRecord != nil;
}

+ (NSArray *)stickerRecordsOfStickerTypeId:(int)stickerTypeId  {
	NSArray *fetchedRecordObjects = [StickerRecord findByAttribute:@"stickerTypeId" withValue:[NSNumber numberWithInt:stickerTypeId] andOrderBy:@"createdAt" ascending:NO];
	
	return fetchedRecordObjects;
}

@end
