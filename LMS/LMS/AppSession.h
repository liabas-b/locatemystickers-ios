//
//  AppSession.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


typedef enum
{
    logout = 0,
    loggin
}   SessionStateType;


@interface AppSession : NSObject

@property (nonatomic, strong) User *user;


+ (AppSession *)defaultSession;

@end
