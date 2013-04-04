//
//  StickerRecord.h
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StickerRecord : NSObject//NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * codeAnnotation;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSNumber * isActive;
@property (nonatomic, assign) int stickerTypeId;//TODO: add to DB

- (id)initWithName:(NSString *)name imageName:(NSString *)imageName codeAnnotation:(NSString *)codeAnnotation;
- (id)initWithDictinary:(NSDictionary *)dictionary;

- (void)debug;

@end
