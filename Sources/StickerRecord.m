//
//  StickerRecord.m
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerRecord.h"
#import "StickersTableViewController.h"
#import "ConventionTools.h"


@implementation StickerRecord

@dynamic stickerId;
@dynamic name;
@dynamic imageName;
@dynamic code;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic isActive;
@dynamic text;
@dynamic stickerTypeId;

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

- (void)setupWithDictionary:(NSDictionary *)dictionary {//codeAnnotation
	if (dictionary) {
		self.name = [dictionary objectForKey:@"name"];
		self.imageName = @"";//LocateMyStickers-QR-small2.png";
		self.code = [dictionary objectForKey:@"code"];//[NSNumber numberWithInt:[[dictionary objectForKey:@"code"] integerValue];//[dictionary objectForKey:@"code"];
		self.stickerId = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] integerValue]];//WARNING: may be bad access
		self.createdAt = [ConventionTools getDate:[dictionary objectForKey:@"created_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
		self.updatedAt = [ConventionTools getDate:[dictionary objectForKey:@"updated_at"] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
		[dictionary objectForKey:@"created_at"];
		self.updatedAt = [dictionary objectForKey:@"updated_at"];
		self.isActive = [NSNumber numberWithBool:[[dictionary objectForKey:@"is_active"] boolValue]];
		self.stickerTypeId = [NSNumber numberWithInt:[[dictionary objectForKey:@"sticker_type_id"] intValue]];//sticker_type_id
		self.text = [dictionary objectForKey:@"text"];
	}
}

- (void)debug {
	NSLog(@"%s - stickerId: %@ | code: %@ | %@ - %@ - %@ - %@ - %@ - %d - %@ - %@", __PRETTY_FUNCTION__, self.stickerId, self.code, self.name,self.imageName, self.stickerId, [self.createdAt description], [self.updatedAt description], [self.isActive boolValue], self.stickerTypeId, self.text);
}

@end
