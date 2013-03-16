//
//  LocationRecord.h
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * idLocation;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;

- (id)initWithDictinary:(NSDictionary *)dictionary;
- (void)debug;

@end
