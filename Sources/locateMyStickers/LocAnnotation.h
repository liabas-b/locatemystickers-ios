//
//  LocAnnotation.h
//  LocationDemo
//
//  Created by local on 12/31/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface LocAnnotation : NSObject <MKAnnotation>

//The MKAnnotation Protocol Properties
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
