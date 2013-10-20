//
//  ABViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

static const int MINIMUM_DELTA_METERS = 10.0;
extern NSString* const keyPathMeasurementArray;

@class LocationRecord;
@class StickerRecord;

@interface LocationManager : CLLocationManager <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray* measurementArray;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (nonatomic, assign) NSString *stickerCode;

- (void)setup;
- (void)start;
- (void)startWithStickerCode:(NSString *)code;
- (void)stop;
- (void)reset;

- (void)addLocationRecordWithDictionary:(NSDictionary *)dictionary;
- (void)addLocationRecord:(LocationRecord *)locationRecord;

- (void)updateLocationRecordsForSticker:(StickerRecord *)stickerRecord success:(void (^)(NSMutableDictionary *JSON))success failure:(void (^)(NSURLRequest *request, NSError *error, id JSON))failure;

@end
