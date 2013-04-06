//
//  ApplicationViewProtocol.h
//  sportel
//
//  Created by Ludovic DE FREITAS on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataContainer.h"

@class DataContainer;

@protocol ApplicationViewProtocol <NSObject>

@required
- (void)dataAvailable:(DataContainer *)data;
- (void)dataError:(NSString *)errorType withData:(DataContainer *)data;
- (void)loadData:(DataContainer *)data;
- (void)showWaitingMessage;

@optional
- (NSString *)getCodeItem;
- (void)dataFileAvailable:(NSData *)data;

@end
