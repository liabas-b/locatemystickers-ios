//
//  AccountRecord.m
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AccountRecord.h"


@implementation AccountRecord

@dynamic idAccount;
@dynamic name;
@dynamic email;
@dynamic createdAt;
@dynamic updatedAt;

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
			self.idAccount = [NSNumber numberWithBool:[[dictionary objectForKey:@"id"] intValue]];
			self.name = [dictionary objectForKey:@"name"];
			self.email = [dictionary objectForKey:@"email"];
			self.createdAt = [dictionary objectForKey:@"created_at"];
			self.updatedAt = [dictionary objectForKey:@"updated_at"];
		}
	}
	return self;
}

- (void)debug {
	NSLog(@"%d - %@ - %@ - %@ - %@", [self.idAccount intValue], self.name, self.email, self.createdAt, self.updatedAt);
}


@end
