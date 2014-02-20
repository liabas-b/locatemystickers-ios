//
//  LocationServices.h
//  Tenjoon
//
//  Created by Adrien Guffens on 11/02/14.
//  Copyright (c) 2014 Team3000. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationServicesCompletionHandler)(id object);

@interface LocationServices : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

+ (LocationServices *)defaultLocationServices;

- (void)startLocationServices:(LocationServicesCompletionHandler)completion;
- (void)stopLocationServices;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocation *lastLocation;

- (void)locationString:(LocationServicesCompletionHandler)completion;

@property (nonatomic, strong) LocationServicesCompletionHandler completion;
@property (nonatomic, strong) LocationServicesCompletionHandler updateCompletion;

@end
