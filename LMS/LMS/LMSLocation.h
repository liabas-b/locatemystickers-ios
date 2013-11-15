//
//  LMSLocation.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//


#import <JSONModel.h>

@protocol LMSLocation
@end

@interface LMSLocation : JSONModel

/*

 is_new: true,
 latitude: 179,
 longitude: 179,
 sticker_code: "4af98a0dc3e02e23e0bf4b9339a0a53c",
 sticker_id: 38,
 updated_at: "2013-11-12T13:23:45Z",
 version: 0
 },
 }
 */

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *stickerCode;
@property (nonatomic, assign) int stickerId;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, assign) int version;
@end
