//
//  DescriptionItem.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "DescriptionItem.h"

@implementation DescriptionItem

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

+ (JSONKeyMapper*)keyMapper
{
	return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
