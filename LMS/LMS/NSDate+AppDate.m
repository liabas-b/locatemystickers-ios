//
//  NSDate+AppDate.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "NSDate+AppDate.h"

@implementation NSDate (AppDate)

+ (NSDate *)getDate:(NSString *)date withFormat:(NSString *)format {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	return ([dateFormat dateFromString:date]);
}

@end
