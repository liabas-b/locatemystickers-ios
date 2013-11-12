//
//  User+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "User.h"

typedef void (^UserManagerHandler)(id object);

@interface User (Manager)

+ (User *)addUpdateWithDictionary:(NSDictionary *)dictionary;
+ (User *)addUpdateWithUser:(User *)user;
+ (User *)addUpdateWithJSON:(NSString *)JSON;

- (void)update:(UserManagerHandler)completion;

@end
