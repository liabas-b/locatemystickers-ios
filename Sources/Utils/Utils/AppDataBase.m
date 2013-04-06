//
//  AppData.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "AppDataBase.h"
//#import "DataBaseConnector.h"

@implementation AppDataBase

@synthesize ApplicationDirectory, FileDirectory;

@synthesize DataBaseConnector;
@synthesize ConfigManager;

- (id)init {
	self = [super init];
	if (self) {
		ApplicationDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	return self;
}

@end
