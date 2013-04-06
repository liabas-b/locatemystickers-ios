//
//  LocationRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LocationRecord+Manager.h"

static NSString *entityName = @"LocationRecord";

@implementation LocationRecord (Manager)

+ (LocationRecord *)addUpdatelocationWithDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)moc {
	LocationRecord *locationRecord = nil;
	
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	//TODO: filtrer recherche sur id == phone
	
	[fetchRequest setEntity:entityStickersRecord];
	
	if (dictionary) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idLocation == %@", [dictionary objectForKey:@"id"]];
		[fetchRequest setPredicate:predicate];
	}
	[fetchRequest setReturnsObjectsAsFaults:YES];
	NSArray *fetchedStickersRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	if ([fetchedStickersRecordObjects count] > 0) {
		locationRecord = [fetchedStickersRecordObjects lastObject];
	}
	else {
		locationRecord = (LocationRecord *)[NSEntityDescription
											insertNewObjectForEntityForName:entityName
											inManagedObjectContext:moc];
	}
	
	//
	if (dictionary) {
		locationRecord.idLocation = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] intValue]];
		locationRecord.latitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"latitude"] floatValue]];
		locationRecord.longitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"longitude"] floatValue]];
		locationRecord.createdAt = [NSDate date];//[dictionary objectForKey:@"created_at"];
		locationRecord.updatedAt = [NSDate date];//[dictionary objectForKey:@"updated_at"];
	}
	return locationRecord;
	
}

+ (NSArray *)locationRecordsInManagedObjectContext:(NSManagedObjectContext *)moc {
	NSError *error;
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	
	//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stickerTypeId == %d", stickerTypeId];
	
	NSArray *sortDescriptors = [NSArray arrayWithObject:
								[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityStickersRecord];
	//	[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	
	NSArray *fetchedRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	
	return fetchedRecordObjects;
}

@end
