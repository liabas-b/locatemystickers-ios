//
//  LMSSticker.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMSStickerConfiguration.h"
#import <JSONModel.h>

@protocol LMSSticker
@end

@interface LMSSticker : JSONModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) double lastLatitude;
@property (nonatomic, assign) double lastLongitude;
@property (nonatomic, strong) NSString *lastLocation;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int stickerTypeId;
@property (nonatomic, strong) NSString * text;

@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int version;

@end
