//
//  NetworkKeys.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "ApiKeys.h"

@implementation ApiKeys

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
	return [super initWithDictionary:dict error:err];
}

- (id)initWithString:(NSString *)string error:(JSONModelError *__autoreleasing *)err {
	return [super initWithString:string error:err];
}

- (id)initWithString:(NSString *)string usingEncoding:(NSStringEncoding)encoding error:(JSONModelError *__autoreleasing *)err {
	return  [super initWithString:string usingEncoding:encoding error:err];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

+ (JSONKeyMapper*)keyMapper
{
	return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
