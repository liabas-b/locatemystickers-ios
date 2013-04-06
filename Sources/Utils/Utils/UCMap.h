//
//  UCMap.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UCMapProtocol.h"

@class MapAnnotation;

@interface UCMap : UIView <MKMapViewDelegate> {
	MKMapView *mapView_;
	id <UCMapProtocol> _delgate;
	NSMutableArray *_annotationsList;
	BOOL _canShowCallout;	
}

- (id)initWithFrame:(CGRect)frame;
- (void)addAnnototion:(MapAnnotation *)annotation;
- (void)deleteAnnotation:(MapAnnotation *)annotation;
- (void)deleteAnnotationByName:(NSString *)nameAnnotation;
- (void)deleteAllAnnotations;

- (void)makePOIVisible;

@property(nonatomic, strong) MKMapView *MapView;
@property(nonatomic, strong) id <UCMapProtocol> Delgate;
//

@property(nonatomic, strong)NSMutableArray *AnnotationsList;
@property(nonatomic, assign)BOOL CanShowCallout;


@end
