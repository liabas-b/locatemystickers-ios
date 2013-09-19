//
//  HistoryRecord+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 9/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryRecord.h"

@interface HistoryRecord (Manager)

+ (HistoryRecord *)addUpdateHistoryWithDictionary:(NSDictionary *)dictionary;

@end
