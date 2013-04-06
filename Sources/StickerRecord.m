//
//  StickerRecord.m
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerRecord.h"
#import "StickersTableViewController.h"


@implementation StickerRecord

@synthesize name;
@synthesize imageName;
@synthesize codeAnnotation;
@synthesize createdAt;
@synthesize updatedAt;
@synthesize isActive;
@synthesize stickerTypeId;

- (id)initWithName:(NSString *)name imageName:(NSString *)imageName codeAnnotation:(NSString *)codeAnnotation {
	self = [super init];
	if (self) {
		/*
		self.name = name;
		self.imageName = imageName;
		self.codeAnnotation = codeAnnotation;
		 */
	}
	return self;
}

- (id)initWithDictinary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		[self setupWithDictionary:dictionary];
	}
	return self;
}

- (void)setupWithDictionary:(NSDictionary *)dictionary {
	if (dictionary) {
		self.name = [dictionary objectForKey:@"name"];
		self.imageName = @"LocateMyStickers-QR-small2.png";
		self.codeAnnotation = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];//WARNING: may be bad access
		self.createdAt = [dictionary objectForKey:@"created_at"];
		//			self.createdAt = [StickersTableViewController getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
		//			self.updatedAt = [StickersTableViewController getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
		self.updatedAt = [dictionary objectForKey:@"updated_at"];
		self.isActive = [NSNumber numberWithBool:[[dictionary objectForKey:@"is_active"] boolValue]];
		self.stickerTypeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"sticker_type_id"] intValue]];//sticker_type_id
	}
}

- (void)debug {
	NSLog(@"%@ - %@ - %@ - %@ - %@ - %d - %@", self.name, self.imageName, self.codeAnnotation, [self.createdAt description], [self.updatedAt description], [self.isActive boolValue], self.stickerTypeId );
}

@end
