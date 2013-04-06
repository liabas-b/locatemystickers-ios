//
//  CryptographyTools.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "CryptographyTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CryptographyTools

+ (NSString*)stringToMD5:(NSString *)str
{
	const char *ptr = [str UTF8String];
	
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(ptr, strlen(ptr), md5Buffer);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		[output appendFormat:@"%02x", md5Buffer[i]];
	
	return output;
}

@end
