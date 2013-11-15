//
//  LMSLocation.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSLocation.h"

@implementation LMSLocation

//@dynamic createdAt;
//@dynamic idLocation;
//@dynamic latitude;
//@dynamic longitude;
//@dynamic updatedAt;
//@dynamic idSticker;

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

+ (JSONKeyMapper*)keyMapper
{
	return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
