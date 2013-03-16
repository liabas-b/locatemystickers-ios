//
//  OptionsRecord.h
//  LMS
//
//  Created by Adrien Guffens on 3/15/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OptionsRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * locatePhoneEnabled;
@property (nonatomic, retain) NSNumber * displayFollowedStickersEnabled;

@end
