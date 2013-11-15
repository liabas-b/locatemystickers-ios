//
//  Stickers+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Stickers.h"
#import "User.h"

typedef void (^StickersManagerHandler)(id object);

@interface Stickers (Manager)

- (void)updateWithUser:(User *)user andBlock:(StickersManagerHandler)completion;

@end
