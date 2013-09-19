//
//  HistoryRecord.h
//  ZXingWidget
//
//  Created by Adrien Guffens on 9/18/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StickerRecord;

@interface HistoryRecord : NSManagedObject

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
@property (nonatomic, retain) StickerRecord *sticker;

@end
