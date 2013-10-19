//
//  ConfigurationStickerRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 10/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerConfigurationRecord+Manager.h"
#import "ConventionTools.h"

@implementation StickerConfigurationRecord (Manager)

+ (StickerConfigurationRecord *)addUpdateWithDictionary:(NSDictionary *)dictionary {
	
	StickerConfigurationRecord *stickerConfigurationRecord = nil;
	
	if (dictionary == nil) {
		return nil;
	}
	
	if ([dictionary objectForKey:@"id"] != [NSNull null]) {
		stickerConfigurationRecord = [StickerConfigurationRecord findFirstByAttribute:@"configurationId" withValue:[dictionary objectForKey:@"id"]];
	}
	if (stickerConfigurationRecord == nil) {
		stickerConfigurationRecord = [StickerConfigurationRecord createEntity];
	}
	
	stickerConfigurationRecord.createdAt = [ConventionTools getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	stickerConfigurationRecord.activate = @([[dictionary objectForKey:@"activate"] boolValue]);
	stickerConfigurationRecord.frequencyUpdate = @([[dictionary objectForKey:@"frequency_update"] intValue]);
	stickerConfigurationRecord.stickerCode = [dictionary objectForKey:@"sticker_code"];
	stickerConfigurationRecord.updatedAt = [ConventionTools getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	stickerConfigurationRecord.configurationId = @([[dictionary objectForKey:@"id"] intValue]);
		
	return stickerConfigurationRecord;
}

@end
