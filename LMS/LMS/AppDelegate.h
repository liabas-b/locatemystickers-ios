//
//  AppDelegate.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LMSAPIManager.h"
#import "AppParameters.h"
#import "AppSession.h"
#import "WebSocketManager.h"
#import "PusherManager.h"
#import "OperationManager.h"
#import "AnalyticsManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LMSAPIManager *apiManager;
@property (nonatomic, strong) AppParameters *appParameters;
@property (nonatomic, strong) AppSession *appSession;
@property (nonatomic, strong) WebSocketManager *websocketManager;
@property (nonatomic, strong) PusherManager *pusherManager;
@property (nonatomic, strong) OperationManager *operationManager;
@property (nonatomic, strong) AnalyticsManager *analyticsManager;

+ (id)appDelegate;


@end
