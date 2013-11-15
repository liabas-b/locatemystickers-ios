//
//  LMSSticker+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSSticker.h"
#import "Locations+Manager.h"

typedef enum {
    StickerTypeDefault = 0,
	StickerTypeSticker,
    StickerTypeIphone,
    StickerTypeAndroid
} StickerTypeId;

@interface LMSSticker (Manager)


- (void)updateLocationsWithBlock:(LocationsManagerHandler)completion;

//


+ (LMSSticker *)addUpdateWithDictionary:(NSDictionary *)dictionary;
+ (LMSSticker *)addUpdateWithUser:(LMSSticker *)sticker;
+ (LMSSticker *)addUpdateWithJSON:(NSString *)JSON;
//


+ (LMSSticker *)addUpdateWithCode:(NSString *)code;
//+ (LMSSticker *)addUpdateWithDictionary:(NSDictionary *)dictionary;

+ (BOOL)stickerIsAlreadyAddedWithCode:(NSString *)code;
+ (NSArray *)stickerOfStickerTypeId:(int)stickerTypeId;

- (void)debug;

@end
