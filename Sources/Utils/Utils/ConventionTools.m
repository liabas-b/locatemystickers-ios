//
//  ConventionTools.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

#import "ConventionTools.h"
#import "Reachability.h"
#import "UIImageResizing.h"

@implementation ConventionTools

#pragma marh - Network

+ (BOOL)isNetworkOn {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
	
    if (internetStatus == NotReachable) {
        return FALSE;
    }
    return TRUE;
}

#pragma marh - File

+ (BOOL)fileExist:(NSString *)aFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	return ([fileManager fileExistsAtPath:aFile]);
}

#pragma mark - Timer

+ (NSDate *)startTimer {
	return ([NSDate date]);
}

+ (void)stopTimer:(NSDate *)start {
	NSDate *methodFinish = [NSDate date];
	NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
	NSLog(@"Execution Time: %f", executionTime);
}

#pragma mark - Date

+ (NSDate *)getDate:(NSString *)date withFormat:(NSString *)format {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	return ([dateFormat dateFromString:date]);
}

+ (NSString *)getStringDate:(NSDate *)date withFormat:(NSString *)format {
	NSDateFormatter *formatD = [[NSDateFormatter alloc] init];
	[formatD setDateFormat:format];
	return ([formatD stringFromDate:date]);
}

+ (BOOL)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath {
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
	
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error])
		return NO;
	return YES;
}

#pragma mark - Diff time

+ (NSString *)getDiffTimeInStringFrom:(NSString *)stringDate withFormat:(NSString *)format {
	NSString *dateFromPublishedDate;
	
	NSDate *baseDate = [ConventionTools getDate:stringDate withFormat:format];
	NSDate *currDate = [NSDate date];
	NSTimeInterval diff = [currDate timeIntervalSinceDate:baseDate];
	
	NSInteger secondsDiff = diff;
	NSInteger minutesDiff = diff / 60;
	NSInteger houresDiff = (diff / 60) / 60;
	NSInteger daysDiff = (((diff / 60) / 60) / 24);
	NSInteger monthsDiff = ((((diff / 60) / 60) / 24 / 31));
	NSInteger yearsDiff = ((((diff / 60) / 60) / 24 / 31 / 12));
	
	if (secondsDiff < 60)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d sec", secondsDiff];
	else if (minutesDiff < 60)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d min", minutesDiff];
	else if (houresDiff < 24)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d hour", houresDiff];
	else if (daysDiff < 31)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d day", daysDiff];
	else if (monthsDiff < 12)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d month", monthsDiff];
	else
		dateFromPublishedDate = [NSString stringWithFormat:@"%d years", yearsDiff];
	
	return dateFromPublishedDate;
}

#pragma mark -  Translator

+ (BOOL)string:(NSString *)sourceString containsString:(NSString *)string {
	NSRange range = [sourceString rangeOfString:string options:NSCaseInsensitiveSearch];
	if (range.location != NSNotFound) {
		return YES;
	}
	return NO;
}

+ (NSString *)numberToString:(NSNumber *)number {
	NSString *res = @"0";
	
	if ([number integerValue] != 0 || [number intValue] != 0)
		res = [NSString stringWithFormat:@"%@", number];
	else if ([number doubleValue] != 0 || [number floatValue] != 0)
		res = [NSString stringWithFormat:@"%@", number];
	else if ([number longLongValue] != 0)
		res = [NSString stringWithFormat:@"%@", number];
	else if ([number boolValue] != 0)
		res = [NSString stringWithFormat:@"%@", ((BOOL)number == YES ? @"true" : @"false")];//INFO: always true
	return res;
}

+ (NSString *)replace:(NSString *)sourceString with:(NSString *)originalString by:(NSString *)stringToReplace {
	return [sourceString stringByReplacingOccurrencesOfString:originalString withString:stringToReplace];
}

#pragma mark - border

+ (void)addBorderToLayer:(CALayer *)layer withBorderRaduis:(float)radius {
	//layer.masksToBounds = YES;
	
	[layer setCornerRadius:radius];//2
	[layer setBorderColor:[UIColor lightGrayColor].CGColor];
	[layer setBorderWidth:1.0f];
	[layer setShadowColor:[UIColor blackColor].CGColor];
	[layer setShadowOpacity:0.6f];
	[layer setShadowRadius:radius];//(radius == 0.0f ? 1.0f : radius) * 2.0f];
	[layer setShadowOffset:CGSizeMake(radius / 4, radius / 4)];
}

+ (void)addBorderToView:(UIView *)view withBorderRaduis:(float)radius {
	//view.clipsToBounds = YES;
	
	[ConventionTools addBorderToLayer:view.layer withBorderRaduis:radius];
}

+ (void)addBorderToView:(UIView *)view andSubviews:(BOOL)subviewEnable withBorderRaduis:(float)radius {
	[ConventionTools addBorderToLayer:view.layer withBorderRaduis:radius];
	
	if (subviewEnable) {
		for (UIView *subview in [view subviews]) {
			[ConventionTools addBorderToView:subview withBorderRaduis:radius];
		}
	}
}

+ (NSString *)formatValue:(int)value forDigits:(int)zeros {
    
    NSString * format = [NSString stringWithFormat:@"%%0%dd", zeros];
    return [NSString stringWithFormat:format, value];
}

+ (void)playSound:(NSString *)aFileName {
	
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
	
	NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], aFileName];
	
	NSLog(@"Playing %@",path);
	
	//INFO: declare a system sound id
	SystemSoundID soundID;
	
	//INFO: Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
	
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
	
	//INFO: Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
}

@end