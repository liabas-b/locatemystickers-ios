//
//  Locations+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Locations.h"
#import "LMSSticker.h"

typedef void (^LocationsManagerHandler)(id object);

@interface Locations (Manager)

//- (void)updateWithSticker:(LMSSticker *)sticker andBlock:(LocationsManagerHandler)completion;
+ (void)updateWithSticker:(LMSSticker *)sticker andBlock:(LocationsManagerHandler)completion;

@end
