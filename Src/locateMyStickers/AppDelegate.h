//
//  AppDelegate.h
//  locateMyStickers
//
//  Created by Adrien Guffens on 2/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "SessionManager.h"
#import "ConnectionManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) ConnectionManager *connectionManager;

+ (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate *)appDelegate;

+ (UIStoryboard *)mainStoryBoard;
+ (BOOL)deviceIsIpad;
+ (BOOL)deviceIsIO6;

@end
