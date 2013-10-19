//
//  LocationRecord.m
//  LMS
//
//  Created by Adrien Guffens on 7/17/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LocationRecord.h"


@implementation LocationRecord

@dynamic createdAt;
@dynamic idLocation;
@dynamic latitude;
@dynamic longitude;
@dynamic updatedAt;
@dynamic idSticker;

- (id)init {
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (id)initWithDictinary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		if (dictionary) {
			self.idLocation = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] intValue]];
			self.latitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"latitude"] floatValue]];
			self.longitude = [NSNumber numberWithFloat:[[dictionary objectForKey:@"longitude"] floatValue]];
			self.createdAt = [dictionary objectForKey:@"created_at"];
			self.updatedAt = [dictionary objectForKey:@"updated_at"];
			self.idSticker = @([[dictionary objectForKey:@"sticker_id"] intValue]);
		}
	}
	return self;
}

- (void)debug {
	NSLog(@"idLocation: %d - idSticker: %d - %f - %f - %@ - %@", [self.idLocation intValue], [self.idSticker intValue], [self.latitude floatValue], [self.longitude floatValue], self.createdAt, self.updatedAt);
}

@end
