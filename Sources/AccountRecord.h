//
//  AccountRecord.h
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccountRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * idAccount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;

- (id)initWithDictinary:(NSDictionary *)dictionary;
- (void)debug;

@end
