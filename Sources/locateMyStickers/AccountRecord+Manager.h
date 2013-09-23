//
//  AccountRecord+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AccountRecord.h"

@interface AccountRecord (Manager)

+ (AccountRecord *)addUpdateWithDictionary:(NSDictionary *)dictionary;

@end
