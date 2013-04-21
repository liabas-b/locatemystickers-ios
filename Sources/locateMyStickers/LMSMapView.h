//
//  LMSMapView.h
//  LMS
//
//  Created by Adrien Guffens on 4/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LMSMapView : MKMapView <MKMapViewDelegate>

@property (nonatomic, strong)NSMutableArray *locationsRecordList;

- (void)updateLocations;

@end
