//
//  Friends.m
//  LMS
//
//  Created by Adrien Guffens on 12/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Friends.h"

@implementation Friends

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

+ (JSONKeyMapper*)keyMapper
{
	return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
