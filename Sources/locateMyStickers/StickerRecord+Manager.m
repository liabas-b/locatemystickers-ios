//
//  StickerRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerRecord+Manager.h"

static NSString *entityName = @"StickerRecord";

@implementation StickerRecord (Manager)

+ (StickerRecord *)addUpdateStickerWithDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)moc {
	StickerRecord *stickerRecord = nil;
	
	//
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	//TODO: filtrer recherche sur id == phone
	
	[fetchRequest setEntity:entityStickersRecord];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codeAnnotation == %@", [dictionary objectForKey:@"id"]];
	[fetchRequest setPredicate:predicate];
	
	[fetchRequest setReturnsObjectsAsFaults:NO];
	NSArray *fetchedStickersRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	if ([fetchedStickersRecordObjects count] > 0) {
		stickerRecord = [fetchedStickersRecordObjects lastObject];
	}
	else {
		stickerRecord = (StickerRecord *)[NSEntityDescription
										  insertNewObjectForEntityForName:entityName
										  inManagedObjectContext:moc];
	}
	
	//
	stickerRecord.name = [dictionary objectForKey:@"name"];
	stickerRecord.imageName = @"LocateMyStickers-QR-small2.png";
	stickerRecord.codeAnnotation = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];//WARNING: may be bad access
	stickerRecord.createdAt = [NSDate date];//[dictionary objectForKey:@"created_at"];
											//	stickerRecord.createdAt = [StickersTableViewController getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
											//			stickerRecord.updatedAt = [StickersTableViewController getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	stickerRecord.updatedAt = [NSDate date];//[dictionary objectForKey:@"updated_at"];
	stickerRecord.isActive = [NSNumber numberWithBool:[[dictionary objectForKey:@"is_active"] boolValue]];
	stickerRecord.stickerTypeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"sticker_type_id"] intValue]];//sticker_type_id
	
	return stickerRecord;
}

+ (NSArray *)stickerRecordsOfStickerTypeId:(int)stickerTypeId managedObjectContext:(NSManagedObjectContext *)moc {
	
	NSError *error;
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stickerTypeId == %d", stickerTypeId];
	
	NSArray *sortDescriptors = [NSArray arrayWithObject:
								[NSSortDescriptor sortDescriptorWithKey:@"createdAt"
															  ascending:YES]];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityStickersRecord];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	
	NSArray *fetchedRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	
	return fetchedRecordObjects;
}

@end
