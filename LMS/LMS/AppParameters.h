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


@property (nonatomic, strong) Parameters *parameters;

@property (nonatomic, strong) NSMutableArray *menuList;
@property (nonatomic, strong) NSMutableArray *sectionsList;

@end
