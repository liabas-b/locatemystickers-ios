//
//  NSString.m
//  sportel
//
//  Created by Adrien Guffens on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)

- (NSString*)MD5
{
	//INFO: Create pointer to the string as UTF8
	const char *ptr = [self UTF8String];
	
	//INFO: Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
	
	//INFO: Create 16 byte MD5 hash value, store in buffer
	CC_MD5(ptr, strlen(ptr), md5Buffer);
	
	//INFO: Convert MD5 value in the buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		[output appendFormat:@"%02x",md5Buffer[i]];
	
	return output;
}

@end
