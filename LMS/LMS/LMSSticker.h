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

@interface LMSSticker : JSONModel

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * lastLocation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stickerConfigurationId;
@property (nonatomic, retain) NSNumber * stickerId;
@property (nonatomic, retain) NSNumber * stickerTypeId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) LMSStickerConfiguration *stickerConfiguration;

@end
