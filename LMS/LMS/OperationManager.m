//
//  OperationManager.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "OperationManager.h"

@implementation OperationManager

- (void)start {
	[[EDQueue sharedInstance] setDelegate:self];
    [[EDQueue sharedInstance] start];
}

- (void)stop {
	[[EDQueue sharedInstance] stop];
}

- (void)queue:(EDQueue *)queue processJob:(NSDictionary *)job completion:(void (^)(EDQueueResult))block
{
	static int i;
	
	
	i += 1;
    sleep(i);
    @try {
		NSLog(@"[job objectForKey:@\"task\"]: %@", [job objectForKey:@"task"]);
		NSLog(@"job: %@", job);
		if ([[job objectForKey:@"task"] isEqualToString:@"success"]) {
            block(EDQueueResultSuccess);
        } else if ([[job objectForKey:@"task"] isEqualToString:@"success1"]) {
            block(EDQueueResultSuccess);
        } else if ([[job objectForKey:@"task"] isEqualToString:@"success2"]) {
            block(EDQueueResultSuccess);
        } else if ([[job objectForKey:@"task"] isEqualToString:@"success3"]) {
            block(EDQueueResultSuccess);
        } else if ([[job objectForKey:@"task"] isEqualToString:@"success4"]) {
            block(EDQueueResultSuccess);
        } else if ([[job objectForKey:@"task"] isEqualToString:@"fail"]) {
            block(EDQueueResultFail);
        } else {
            block(EDQueueResultCritical);
        }
    }
    @catch (NSException *exception) {
        block(EDQueueResultCritical);
    }
}

//- (EDQueueResult)queue:(EDQueue *)queue processJob:(NSDictionary *)job
//{
//    sleep(1);
//
//    @try {
//        if ([[job objectForKey:@"task"] isEqualToString:@"success"]) {
//            return EDQueueResultSuccess;
//        } else if ([[job objectForKey:@"task"] isEqualToString:@"fail"]) {
//            return EDQueueResultFail;
//        }
//    }
//    @catch (NSException *exception) {
//        return EDQueueResultCritical;
//    }
//
//    return EDQueueResultCritical;
//}

//

- (void)enqueueWithData:(id)data forTask:(NSString *)task {
	[[EDQueue sharedInstance] enqueueWithData:data forTask:task];
}

@end
