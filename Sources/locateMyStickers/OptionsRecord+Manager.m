//
//  OptionsRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OptionsRecord+Manager.h"

static NSString *entityName = @"OptionsRecord";

@implementation OptionsRecord (Manager)

+ (OptionsRecord *)addUpdateOptionsWithDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)moc {
	OptionsRecord *optionsRecord = nil;
	
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	[fetchRequest setEntity:entityStickersRecord];
	if (dictionary) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idOptions == %@", [dictionary objectForKey:@"id"]];
		[fetchRequest setPredicate:predicate];
	}
	[fetchRequest setReturnsObjectsAsFaults:YES];
	NSArray *fetchedStickersRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	if ([fetchedStickersRecordObjects count] > 0) {
		optionsRecord = [fetchedStickersRecordObjects lastObject];
	}
	else {
		optionsRecord = (OptionsRecord *)[NSEntityDescription
										  insertNewObjectForEntityForName:entityName
										  inManagedObjectContext:moc];
	}
	if (dictionary) {
		optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:[[dictionary objectForKey:@"locate_phone_enabled"] boolValue]];
		optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:[[dictionary objectForKey:@"display_followed_stickers_enabled"] boolValue]];
		optionsRecord.idOption = [NSNumber numberWithInt:[[dictionary objectForKey:@"idOption"] intValue]];
	}
	return optionsRecord;

}

+ (NSArray *)optionsRecordsInManagedObjectContext:(NSManagedObjectContext *)moc {
	NSError *error;
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stickerTypeId == %d", stickerTypeId];
	
//	NSArray *sortDescriptors = [NSArray arrayWithObject:
//								[NSSortDescriptor sortDescriptorWithKey:@"createdAt"
//			  ascending:YES]];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityStickersRecord];
	//[fetchRequest setPredicate:predicate];
//	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	
	NSArray *fetchedRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	
	return fetchedRecordObjects;
}

@end
