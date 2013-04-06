//
//  DebugTools.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "DebugTools.h"

@implementation DebugTools

+ (void)addDebug: (NSObject *)curentClass withMethode: (NSString *)methode andType:(typeDebug)type andDetail:(id)detail {
	
	NSMutableArray *hashTableType = [[NSMutableArray alloc] initWithObjects:@"[INFORMATION]", @"[WARNING]    ", @"[ERROR]      ", nil];
	NSString *className = NSStringFromClass([curentClass class]);
	
	NSLog(@"%@ {%@} (%@) -> %@.", [hashTableType objectAtIndex:type], className, methode, detail);
	
	NCLog(YES, @"%@", @"test");
}

@end
