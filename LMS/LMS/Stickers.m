//
//  Stickers.m
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "Stickers.h"

@implementation Stickers

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

+ (JSONKeyMapper*)keyMapper
{
	return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
