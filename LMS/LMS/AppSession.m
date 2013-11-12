//
//  AppSession.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "AppSession.h"
#import "User+Manager.h"

@implementation AppSession

+ (AppSession *)defaultSession
{
    static AppSession *_sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSession = [[self alloc] init];
    });
    
    return _sharedSession;
}

- (id)init {
	self = [super init];
	if (self) {
#warning TO IMPLEMENENT
		//TODO: check in cache if already logged if yes --> load user
	}
	return self;
}


@end
