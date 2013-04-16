//
//  AccountRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AccountRecord+Manager.h"

static NSString *entityName = @"AccountRecord";

@implementation AccountRecord (Manager)

+ (AccountRecord *)addUpdateAccountWithDictionary:(NSDictionary *)dictionary {

	AccountRecord *accountRecord = [AccountRecord findFirstByAttribute:@"idAccount" withValue:[dictionary objectForKey:@"id"]];
	if (accountRecord == nil) {
		accountRecord = [AccountRecord createEntity];
	}
		accountRecord.idAccount = [NSNumber numberWithBool:[[dictionary objectForKey:@"id"] intValue]];
		accountRecord.name = [dictionary objectForKey:@"name"];
		accountRecord.email = [dictionary objectForKey:@"email"];
		accountRecord.createdAt = [NSDate date];//[dictionary objectForKey:@"created_at"];
		accountRecord.updatedAt = [NSDate date];//[dictionary objectForKey:@"updated_at"];

	return accountRecord;
}
/*
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	[fetchRequest setEntity:entityStickersRecord];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idAccount == %@", [dictionary objectForKey:@"id"]];
	[fetchRequest setPredicate:predicate];
	
	[fetchRequest setReturnsObjectsAsFaults:NO];
	NSArray *fetchedStickersRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	if ([fetchedStickersRecordObjects count] > 0) {
		accountRecord = [fetchedStickersRecordObjects lastObject];
	}
	else {
		accountRecord = (AccountRecord *)[NSEntityDescription
										  insertNewObjectForEntityForName:entityName
										  inManagedObjectContext:moc];
	}
	
	accountRecord.idAccount = [NSNumber numberWithBool:[[dictionary objectForKey:@"id"] intValue]];
	accountRecord.name = [dictionary objectForKey:@"name"];
	accountRecord.email = [dictionary objectForKey:@"email"];
	accountRecord.createdAt = [NSDate date];//[dictionary objectForKey:@"created_at"];
	accountRecord.updatedAt = [NSDate date];//[dictionary objectForKey:@"updated_at"];
	
	return accountRecord;


}

+ (NSArray *)accountsRecordsInManagedObjectContext:(NSManagedObjectContext *)moc {
	NSError *error;
	NSEntityDescription *entityStickersRecord = [NSEntityDescription entityForName:entityName
															inManagedObjectContext:moc];
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stickerTypeId == %d", stickerTypeId];
	
	NSArray *sortDescriptors = [NSArray arrayWithObject:
								[NSSortDescriptor sortDescriptorWithKey:@"createdAt"
															  ascending:YES]];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityStickersRecord];
	//[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	
	NSArray *fetchedRecordObjects = [moc executeFetchRequest:fetchRequest error:&error];
	
	return fetchedRecordObjects;
}
 */
@end
