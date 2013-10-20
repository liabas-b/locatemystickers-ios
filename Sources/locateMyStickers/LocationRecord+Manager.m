//
//  LocationRecord+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LocationRecord+Manager.h"
#import "MagicalRecord.h"
#import "ConventionTools.h"

static NSString *entityName = @"LocationRecord";

@implementation LocationRecord (Manager)

+ (LocationRecord *)addUpdateWithDictionary:(NSDictionary *)dictionary {

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
	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	
//		[MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
			locationRecord.idLocation = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] intValue]];
			locationRecord.idSticker = @([[dictionary objectForKey:@"sticker_id"] intValue]);
			
			locationRecord.latitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"latitude"] floatValue]];
			locationRecord.longitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"longitude"] floatValue]];
			locationRecord.createdAt = [ConventionTools getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
			locationRecord.updatedAt = [ConventionTools getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
			
			
			[locationRecord debug];
//			[[NSManagedObjectContext defaultContext] saveNestedContexts];
	
//		} completion:^(BOOL success, NSError *error) {
//			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
//				[[NSManagedObjectContext defaultContext] save:nil];
//			}];
//		}];
//	});
	
		

	return locationRecord;
	
}

//		} completion:^(BOOL success, NSError *error) {
//			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
//				[[NSManagedObjectContext defaultContext] save:nil];
//			}];
//		}];

@end
