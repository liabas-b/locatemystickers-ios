//
//  AppParameters.h
//  wonderapp
//
//  Created by MEETINEO on 12/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Parameters.h"
//@class Parameters;

typedef enum
{
    noLogin = 0,
    classicLogin,
    interestLogin
    
}   LoginTypeValue;

@interface AppParameters : NSObject

+ (AppParameters *)defaultParameters;

@property (atomic, strong, readonly) NSNumber       *eventID;
@property (nonatomic, strong, readonly) NSString    *googleAnalyticsKey;
@property (nonatomic, strong, readonly) NSArray     *menuItemOrder;
@property (nonatomic, assign, readonly) NSInteger   loginType;
@property (nonatomic, strong, readonly) NSString    *phoneLocalLanguage;

@property (nonatomic, strong, readonly) NSString *color;
@property (nonatomic, strong, readonly) NSNumber *liveMessagesEnable;

@property (nonatomic, strong) Parameters *parameters;

@end
