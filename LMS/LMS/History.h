//
//  History.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMSSticker.h"

@interface History : NSObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * historyId;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * notificationConfirmed;
@property (nonatomic, retain) NSNumber * notificationLevel;
@property (nonatomic, retain) NSNumber * notify;
@property (nonatomic, retain) NSString * operation;
@property (nonatomic, retain) NSNumber * stickerId;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) LMSSticker *sticker;

@end
