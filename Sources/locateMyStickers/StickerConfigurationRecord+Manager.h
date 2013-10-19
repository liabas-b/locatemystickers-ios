//
//  ConfigurationStickerRecord+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 10/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerConfigurationRecord.h"

@interface StickerConfigurationRecord (Manager)

+ (StickerConfigurationRecord *)addUpdateWithDictionary:(NSDictionary *)dictionary;

@end
