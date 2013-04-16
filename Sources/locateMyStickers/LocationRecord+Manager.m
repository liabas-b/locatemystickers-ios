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

+ (LocationRecord *)addUpdatelocationWithDictionary:(NSDictionary *)dictionary {

	LocationRecord *locationRecord = nil;
	
	if (dictionary == nil) {
		locationRecord = [LocationRecord createEntity];
		return locationRecord;
	}
	
	if ([dictionary objectForKey:@"id"] != [NSNull null]) {
		locationRecord = [LocationRecord findFirstByAttribute:@"idLocation" withValue:[dictionary objectForKey:@"id"]];
	}
	if (locationRecord == nil) {
		locationRecord = [LocationRecord createEntity];
	}
	
	locationRecord.idLocation = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] intValue]];
	locationRecord.latitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"latitude"] floatValue]];
	locationRecord.longitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"longitude"] floatValue]];
#warning BAD date setting 
	locationRecord.createdAt = [NSDate date];//[dictionary objectForKey:@"created_at"];
	locationRecord.updatedAt = [NSDate date];//[dictionary objectForKey:@"updated_at"];
	
	[[NSManagedObjectContext defaultContext] saveNestedContexts];
	
	return locationRecord;
	
}

@end
