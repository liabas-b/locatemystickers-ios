//
//  StickerConfigurationRecord.h
//  LMS
//
//  Created by Adrien Guffens on 10/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StickerConfigurationRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * activate;
@property (nonatomic, retain) NSNumber * configurationId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * frequencyUpdate;
@property (nonatomic, retain) NSString * stickerCode;
@property (nonatomic, retain) NSDate * updatedAt;

@end
