//
//  LMSLocation.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSLocation : NSObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * idLocation;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * idSticker;

@end
