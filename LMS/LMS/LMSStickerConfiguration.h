//
//  LMSStickerConfiguration.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface LMSStickerConfiguration : JSONModel

@property (nonatomic, retain) NSNumber *activate;
@property (nonatomic, retain) NSNumber *configurationId;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSNumber *frequencyUpdate;
@property (nonatomic, retain) NSString *stickerCode;
@property (nonatomic, retain) NSDate *updatedAt;

@end
