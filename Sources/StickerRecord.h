//
//  StickerRecord.h
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StickerRecord : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * codeAnnotation;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * stickerTypeId;//TODO: add to DB

- (id)initWithName:(NSString *)name imageName:(NSString *)imageName codeAnnotation:(NSString *)codeAnnotation;
- (id)initWithDictinary:(NSDictionary *)dictionary;

- (void)setupWithDictionary:(NSDictionary *)dictionary;

- (void)debug;

@end
