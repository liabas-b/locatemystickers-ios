//
//  Friends.h
//  LMS
//
//  Created by Adrien Guffens on 12/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"

@protocol Friends
@end

@interface Friends : JSONModel

@property (strong, nonatomic) NSArray<User> *friends;

@end
