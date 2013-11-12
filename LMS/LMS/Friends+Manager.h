//
//  Friends+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 12/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Friends.h"

typedef void (^FriendsManagerHandler)(id object);

@interface Friends (Manager)

- (void)updateWithUser:(User *)user andBlock:(FriendsManagerHandler)completion;

@end
