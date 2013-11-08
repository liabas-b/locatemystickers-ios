//
//  AppDelegate.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LMSAPIManager.h"
#import "WebSocketManager.h"
#import "OperationManager.h"
#import "AnalyticsManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LMSAPIManager *apiManager;
@property (nonatomic, strong) WebSocketManager *websocketManager;
@property (nonatomic, strong) OperationManager *operationManager;
@property (nonatomic, strong) AnalyticsManager *analyticsManager;

@end
