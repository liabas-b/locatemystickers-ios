//
//  StickersManager.h
//  LMS
//
//  Created by Adrien Guffens on 4/14/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StickerRecord;
@class StickerConfigurationRecord;
@class AFHTTPRequestOperation;

static NSString* const keyStickerAlreadyExistOnWebService = @"stickerAlreadyExistOnWebService";

static NSString* const keyAddStickerRecord = @"addStickerRecord";
static NSString* const keyUpdateStickerRecord = @"updateStickerRecord";
static NSString* const keyRemoveStickerRecord = @"removeStickerRecord";

static NSString* const keyAddStickerConfigurationRecord = @"addStickerConfigurationRecord";
static NSString* const keyUpdateStickerConfigurationRecord = @"updateStickerConfigurationRecord";
static NSString* const keyRemoveStickerConfigurationRecord = @"removeStickerConfigurationRecord";

@interface StickersManager : NSObject

- (BOOL)stickerAlreadyExistOnPhoneWithCode:(NSString *)code;
- (BOOL)stickerAlreadyExistOnPhone:(StickerRecord *)stickerRecord;

- (void)stickerAlreadyExistOnWebServiceWithCode:(NSString *)code;
- (void)stickerAlreadyExistOnWebServiceWithDictionary:(NSDictionary *)dictionary;
- (void)stickerAlreadyExistOnWebService:(StickerRecord *)stickerRecord;

- (void)addStickerRecordWithDictionary:(NSDictionary *)dictionary;
- (void)addStickerRecord:(StickerRecord *)stickerRecord;
- (void)updateStickerRecordWithDictionary:(NSDictionary *)dictionary;
- (void)updateStickerRecord:(StickerRecord *)stickerRecord;
- (void)removeStickerRecordWithCode:(NSString *)code;
- (void)removeStickerRecord:(StickerRecord *)stickerRecord;
- (void)updateStickerRecordWithStickerRedord:(StickerRecord *)stickerRecord success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error))failure;
- (void)getStickersRecordWithSuccess:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *erro, id JSON))failure;

//INFO: configuration
- (void)getStickerConfigurationRecordWithStickerRecord:(StickerRecord *)stickerRecord success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error))failure;
- (void)getStickerConfigurationRecordWithStickerCode:(NSString *)stickerCode success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error))failure;
- (void)updateStickerConfigurationRecordWithDictionary:(NSMutableDictionary *)dictionary;
- (void)updateStickerConfigurationRecord:(StickerConfigurationRecord *)stickerConfigurationRecord;
- (void)addStickerConfigurationRecordWithDictionary:(NSDictionary *)dictionary;
- (void)addStickerConfigurationRecord:(StickerConfigurationRecord *)stickerConfigurationRecord;


@end
