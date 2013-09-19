//
//  HistoryRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 9/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "HistoryRecord+Manager.h"
#import "ConventionTools.h"
#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

@implementation HistoryRecord (Manager)

+ (HistoryRecord *)addUpdateHistoryWithDictionary:(NSDictionary *)dictionary {

	HistoryRecord *historyRecord = nil;
	
	if (dictionary == nil) {
		//historyRecord = [HistoryRecord createEntity];
		return nil;//historyRecord;
	}
	
	if ([dictionary objectForKey:@"id"] != [NSNull null]) {
		historyRecord = [HistoryRecord findFirstByAttribute:@"stickerId" withValue:[dictionary objectForKey:@"id"]];
	}
	if (historyRecord == nil) {
		historyRecord = [HistoryRecord createEntity];
	}
	
	historyRecord.createdAt = [ConventionTools getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	historyRecord.historyId = @([[dictionary objectForKey:@"history_id"] intValue]);
	historyRecord.messageId = @([[dictionary objectForKey:@"message_id"] intValue]);
	historyRecord.locationId = @([[dictionary objectForKey:@"location_id"] intValue]);
	historyRecord.notificationConfirmed = @([[dictionary objectForKey:@"location_id"] intValue]);
	historyRecord.notificationLevel = @([[dictionary objectForKey:@"notification_level"] intValue]);
	historyRecord.notify = @([[dictionary objectForKey:@"notify"] intValue]);
	historyRecord.stickerId = @([[dictionary objectForKey:@"sticker_id"] intValue]);
	historyRecord.operation = [dictionary objectForKey:@"operation"];
	historyRecord.subject = [dictionary objectForKey:@"subject"];
	historyRecord.updatedAt = [ConventionTools getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	historyRecord.userId = @([[dictionary objectForKey:@"sticker_id"] intValue]);
	
	StickerRecord *stickerRecord = [StickerRecord findFirstByAttribute:@"stickerId" withValue:historyRecord.stickerId];
	[historyRecord setSticker:stickerRecord];
	
	return historyRecord;
}

@end
