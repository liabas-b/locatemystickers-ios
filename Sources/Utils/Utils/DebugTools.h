//
//  DebugTools.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

/**
 Class for debugging
 @author Adrien Guffens http://www.locatemystickers.com
 */

#import <Foundation/Foundation.h>


/**
 replace NSLog (log function) to display detailed output
 
 @deprecated replace by addDebug static methode 
 */

#define NCLog(enable, s, ...) \
if (enable)\
NSLog(@"<%@:%d|%@> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__,\
NSStringFromSelector(_cmd),\
[NSString stringWithFormat:(s), ##__VA_ARGS__])


/**
 An enumeration of bug display type
 */
typedef enum typeDebug {
	information, /**< A basic information */
	warning, /**< A warning  */
	error /**< A error  */
} typeDebug;

/**
 Debug class to centralize the debug output
 TODO:
 - ios: use testflight SDK
 - write debug on socket
 - write debug on file
 */
@interface DebugTools : NSObject

/**
 Display debug
 @param object source
 @param methode source
 @param type of debug
 @param detail (pointer), can be a string, an array ...
 
 */
+ (void)addDebug:(NSObject *)currentClass withMethode:(NSString *)methode andType:(typeDebug)type andDetail:(id)detail;
//TODO: add debug with object which descibe the log

@end
