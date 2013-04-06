//
//  LocAnnotation.m
//  LocationDemo
//
//  Created by local on 12/31/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "LocAnnotation.h"
#import "CLLocation (Strings).h"

static NSString* const strProgressing = @"Processing...";

@interface LocAnnotation ()

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *subtitle;

@property (nonatomic, strong) CLGeocoder* reverseGeocoder;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@end

@implementation LocAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        self.coordinate = coordinate;
        self.title = [CLLocation localizedCoordinateString:coordinate];
        self.subtitle = [self.dateFormatter stringFromDate:[NSDate date]];

        //self.reverseGeocoder = [CLGeocoder new];
        //[self startReverseGeocoding];
    }

    return self;
}

- (void)startReverseGeocoding
{
    if (self.reverseGeocoder.isGeocoding == YES)
        return;

    CLLocation* location = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    [self.reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
#ifdef DEBUG
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
#endif
        if (error){
#ifdef DEBUG
            NSLog(@"Geocode failed with error: %@", error);
#endif
            [self displayError:error];
            return;
        }
#ifdef DEBUG
        NSLog(@"Received placemarks: %@", placemarks);
#endif
        [self processPlacemarks:placemarks];
    }];
}

- (void)processPlacemarks:(NSArray*)placemarks
{
    dispatch_async(dispatch_get_main_queue(),^ {
        CLPlacemark *placemark = placemarks[0];

        self.title = placemark.thoroughfare;
        self.subtitle = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    });
}

// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        NSString *message = nil;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled: message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default: message = [error description];
                break;
        }

        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                 message:message
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    });   
}

#pragma mark -- Helper methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    }
    return _dateFormatter;
}

@end
