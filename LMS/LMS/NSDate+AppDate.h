//
//  NSDate+AppDate.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AppDate)

+ (NSDate *)getDate:(NSString *)date withFormat:(NSString *)format;

@end
