//
//  LocationRecord+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LocationRecord.h"

@interface LocationRecord (Manager)

+ (LocationRecord *)addUpdateWithDictionary:(NSDictionary *)dictionary;


@end
