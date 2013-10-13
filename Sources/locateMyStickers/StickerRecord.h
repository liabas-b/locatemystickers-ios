//
//  StickerRecord.h
//  LMS
//
//  Created by Adrien Guffens on 10/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StickerRecord : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stickerId;
@property (nonatomic, retain) NSNumber * stickerTypeId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * color;

@end
