//
//  OperationManager.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "EDQueue.h"

@interface OperationManager : NSObject <EDQueueDelegate>

- (void)start;
- (void)stop;

- (void)enqueueWithData:(id)data forTask:(NSString *)task;

@end
