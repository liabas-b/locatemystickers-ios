//
//  StickersManager.h
//  LMS
//
//  Created by Adrien Guffens on 4/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StickerRecord;

static NSString* const keyStickerAlreadyExistOnWebService = @"stickerAlreadyExistOnWebService";
static NSString* const keyAddStickerRecord = @"addStickerRecord";

@interface StickerManager : NSObject

- (BOOL)stickerAlreadyExistOnPhoneWithCode:(NSString *)code;
- (BOOL)stickerAlreadyExistOnPhone:(StickerRecord *)stickerRecord;

- (void)stickerAlreadyExistOnWebServiceWithCode:(NSString *)code;
- (void)stickerAlreadyExistOnWebServiceWithDictionary:(NSDictionary *)dictionary;
- (void)stickerAlreadyExistOnWebService:(StickerRecord *)stickerRecord;

//- (BOOL)codeIsValid:(NSString *)code;

- (void)addStickerRecordWithDictionary:(NSDictionary *)dictionary;
- (void)addStickerRecord:(StickerRecord *)stickerRecord;
- (void)removeStickerRecordWithCode:(NSString *)code;
- (void)removeStickerRecord:(StickerRecord *)stickerRecord;

@end
