//
//  StickerRecord+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StickerRecord.h"

@interface StickerRecord (Manager)

+ (StickerRecord *)addUpdateStickerWithCode:(NSString *)code;
+ (StickerRecord *)addUpdateStickerWithDictionary:(NSDictionary *)dictionary;

+ (BOOL)stickerIsAlreadyAddedWithCode:(NSString *)code;

+ (NSArray *)stickerRecordsOfStickerTypeId:(int)stickerTypeId;


@end
