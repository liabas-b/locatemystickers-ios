//
//  ABViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

extern NSString* const keyPathMeasurementArray;

@interface LocationManager : CLLocationManager <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray* measurementArray;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (nonatomic, assign) int trackingStickerId;

- (void)setup;
- (void)start;
- (void)startWithStickerTrackingId:(int)trackingStickerId;
- (void)stop;
- (void)reset;

@end
