//
//  LMSSticker+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSSticker+Manager.h"
#import "NSDate+AppDate.h"
#import "LMSStickerConfiguration.h"
#import "LMSStickerConfiguration+Manager.h"

@implementation LMSSticker (Manager)

+ (LMSSticker *)addUpdateWithCode:(NSString *)code {//managedObjectContext:(NSManagedObjectContext *)moc {
	LMSSticker *sticker = nil;//[LMSSticker findFirstByAttribute:@"code" withValue:code];
	/*
	if (sticker == nil) {
		sticker = [LMSSticker findFirstByAttribute:@"stickerId" withValue:code];
		if (sticker == nil) {
			sticker = [LMSSticker createEntity];
			
			sticker.code = code;
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		}
	}
	*/
	return sticker;
}

+ (LMSSticker *)addUpdateWithDictionary:(NSDictionary *)dictionary {
	LMSSticker *sticker = nil;
	
	/*
	if (dictionary == nil) {
		sticker = [LMSSticker createEntity];
		return sticker;
	}
	
	if ([dictionary objectForKey:@"code"] != [NSNull null]) {
		NSLog(@"%s %@", __PRETTY_FUNCTION__, [dictionary objectForKey:[dictionary objectForKey:@"code"]]);
		sticker = [sticker findFirstByAttribute:@"code" withValue:[dictionary objectForKey:@"code"]];
	}
	else if ([dictionary objectForKey:@"id"] != [NSNull null]) {
		sticker = [sticker findFirstByAttribute:@"stickerId" withValue:[dictionary objectForKey:@"id"]];
	}
	if (sticker == nil) {
		sticker = [sticker createEntity];
	}
	*/
	
	sticker.name = [dictionary objectForKey:@"name"];
	sticker.code = [dictionary objectForKey:@"code"] != [NSNull null] ? [dictionary objectForKey:@"code"] : nil;
	sticker.imageName = @"";
	sticker.stickerId = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] intValue]];
	sticker.createdAt = [NSDate getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	sticker.updatedAt = [NSDate getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	//	sticker.isActive = [NSNumber numberWithBool:[[dictionary objectForKey:@"is_active"] boolValue]];
	sticker.stickerTypeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"sticker_type_id"] intValue]];
	sticker.text = [dictionary objectForKey:@"text"] != [NSNull null] ? [dictionary objectForKey:@"text"] : nil;
	sticker.color = [dictionary objectForKey:@"color"] != [NSNull null] ? [dictionary objectForKey:@"color"] : nil;
	//	sticker.frenquencyUpdate = @([[dictionary objectForKey:@"frequency_update"] intValue]);
	sticker.lastLocation = [dictionary objectForKey:@"last_location"] != [NSNull null] ? [dictionary objectForKey:@"last_location"] : nil;
	
	LMSStickerConfiguration *stickerConfiguration = nil;//[LMSStickerConfiguration findFirstByAttribute:@"configurationId" withValue:sticker.stickerConfigurationId];
	sticker.stickerConfiguration = stickerConfiguration;
	
	/*
	if (stickerConfiguration == nil) {
		[[AppDelegate appDelegate].stickerManager getStickerConfigurationRecordWithsticker:sticker success:^(NSMutableDictionary *JSON) {
			NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
			StickerConfigurationRecord *stickerConfigurationRecord = [StickerConfigurationRecord addUpdateWithDictionary:JSON];
			sticker.stickerConfiguration = stickerConfigurationRecord;
			
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		} failure:^(NSURLRequest *request, NSError *error) {
			NSLog(@"%s | request: %@ - error: %@", __PRETTY_FUNCTION__, [request description], [error description]);
		}];
	}
	
	[[NSManagedObjectContext defaultContext] saveNestedContexts];
	*/
	return sticker;
}

+ (BOOL)stickerIsAlreadyAddedWithCode:(NSString *)code {
	/*
	sticker *sticker = [sticker findFirstByAttribute:@"code" withValue:code];
	
	return sticker != nil;
	 */
	return NO;
}

+ (NSArray *)stickerOfStickerTypeId:(int)stickerTypeId  {
/*
 NSArray *fetchedRecordObjects = [sticker findByAttribute:@"stickerTypeId" withValue:[NSNumber numberWithInt:stickerTypeId] andOrderBy:@"createdAt" ascending:NO];
	
	return fetchedRecordObjects;
*/
	return nil;
 }

- (void)debug {
	DLog(@"code: %@ - color: %@ - createdAt: %@ - imageName: %@ - lastLocation: %@ - name: %@ - stickerConfigurationId: %@ - stickerId: %@ - stickerTypeId: %@ - text: %@ - updatedAt: %@ - stickerConfiguration: %@", self.code, self.color, self.createdAt, self.imageName, self.lastLocation, self.name, self.stickerConfigurationId, self.stickerId, self.stickerTypeId, self.text, self.updatedAt, self.stickerConfiguration);

	DLog(@"[stickerConfiguration debug]:")
	[self.stickerConfiguration debug];
}

@end
