//
//  LMSStickerConfiguration.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSStickerConfiguration.h"

@implementation LMSStickerConfiguration

@dynamic activate;
@dynamic configurationId;
@dynamic createdAt;
@dynamic frequencyUpdate;
@dynamic stickerCode;
@dynamic updatedAt;

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

+ (JSONKeyMapper*)keyMapper
{
	return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
