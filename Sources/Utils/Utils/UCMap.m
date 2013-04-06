//
//  UCMap.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "UCMap.h"
#import "DebugTools.h"

#import "MapAnnotation.h"

@implementation UCMap

@synthesize MapView = _mapView;
@synthesize Delgate = _delgate;
@synthesize AnnotationsList = _annotationsList;
@synthesize CanShowCallout = _canShowCallout;

- (id)initWithFrame:(CGRect)frame {
	[DebugTools addDebug:self
			 withMethode:@"- (id)initWithFrame:(CGRect)frame"
				 andType:information
			   andDetail:@""];
	
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self->_mapView = [[MKMapView alloc] initWithFrame:self.bounds];
		self->_mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self->_mapView setDelegate:self];
		[self addSubview:self->_mapView];
		self->_canShowCallout = YES;
		
		self->_annotationsList = [[NSMutableArray alloc] init];
		self->_mapView.showsUserLocation = YES;
	}
    return self;
}

#pragma mark - Add/Delete Annotation

- (void)addAnnototion:(MapAnnotation *)annotation {
	[self->_mapView addAnnotation:annotation];
	[self->_annotationsList addObject:annotation];
}

- (void)deleteAnnotation:(MapAnnotation *)annotation {
	[self->_mapView removeAnnotation:annotation];
	[self->_annotationsList removeObject:annotation];
}

- (void)deleteAnnotationByName:(NSString *)nameAnnotation {
	for (id<MKAnnotation> annotation in self->_annotationsList) {
		if ([annotation isKindOfClass:[MapAnnotation class]])
		{
			MapAnnotation *location = (MapAnnotation *)annotation;
			if ([location.title isEqual:nameAnnotation])
			{
				[self deleteAnnotation:annotation];
				return;
			}
		}
	}
}

- (void)deleteAllAnnotations {
	for (int i = [self->_annotationsList count]; i > 0; --i) {
		if ([[self->_annotationsList objectAtIndex:i - 1] isKindOfClass:[MapAnnotation class]])
		{
			[self deleteAnnotation:[self->_annotationsList objectAtIndex:i - 1]];
		}
	}
}

#pragma mark - center POI

- (void)makePOIVisible {
	MKMapRect flyTo = MKMapRectNull;
	
	NSInteger nbPOI = 0;
	for (id<MKAnnotation> annotation in self->_annotationsList)
		nbPOI++;
	if (nbPOI > 1)
	{
		for (id <MKAnnotation> annotation in self->_annotationsList) {
			MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
			MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
			if (MKMapRectIsNull(flyTo))
				flyTo = pointRect;
			else
				flyTo = MKMapRectUnion(flyTo, pointRect);
		}
	}
	else {
		for (id <MKAnnotation> annotation in self->_annotationsList) {
			MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
			MKMapRect pointRect = MKMapRectMake(annotationPoint.x - 400, annotationPoint.y - 400, 800, 800);
			flyTo = pointRect;
		}
	}
	self->_mapView.visibleMapRect = flyTo;
}

#pragma mark - Map Systeme

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	[DebugTools addDebug:self
			 withMethode:@"- (void)mapView:(MKMapView *)mapViewdidUpdateUserLocation:(MKUserLocation *)userLocation"
				 andType:information
			   andDetail:@""];
	//TODO: check si utile
	//if (self.delgate_)
	//		[self.delgate_ mapView:mapView didUpdateUserLocation:userLocation];
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation {
	[DebugTools addDebug:self
			 withMethode:@"- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id) annotation"
				 andType:information
			   andDetail:@""];
	
	MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	
	if ([annotation isKindOfClass:[MapAnnotation class]])
	{
		MapAnnotation *location = (MapAnnotation *)annotation;
		[DebugTools addDebug:self
				 withMethode:@"- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation"
					 andType:information
				   andDetail:[NSString stringWithFormat:@"%@ - %@ | %@ - %@", location.type, location.title, location.pinImage, location.leftIconView]];
		
		//INFO: possibilite de trier en foncton du type/title
		
		
		UIImage *pinImage = [UIImage imageNamed:location.pinImage];
		[customAnnotationView setImage:pinImage];
		
		customAnnotationView.canShowCallout = self->_canShowCallout;
		
		UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:location.leftIconView]];
		customAnnotationView.leftCalloutAccessoryView = leftIconView;
		
		UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[rightButton addTarget:self action:@selector(didSelectAnnotation:) forControlEvents:UIControlEventTouchUpInside];
		customAnnotationView.rightCalloutAccessoryView = rightButton;
	}
	else
	{
		MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
		customPinView.pinColor = MKPinAnnotationColorRed;
		customPinView.animatesDrop = NO;
		customPinView.canShowCallout = NO;
		return customPinView;
		
	}
	return customAnnotationView;
	
	//NOTE: differente facon pour faire des pins
	//if (self.delgate_) {
	/*
	 MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	 customPinView.pinColor = MKPinAnnotationColorPurple;
	 //    customPinView.animatesDrop = YES;
	 customPinView.canShowCallout = YES;
	 return customPinView;
	 */
	/*
	 MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	 UIImage *pinImage = [UIImage imageNamed:@"first"];
	 [customAnnotationView setImage:pinImage];
	 customAnnotationView.canShowCallout = YES;
	 return customAnnotationView;
	 */
}

#pragma mark - Map Protocol

- (IBAction) didSelectAnnotation:(id) sender {
	//call delegate and send id
	if ([self->_delgate respondsToSelector:@selector(didSelectAnnotation:)]) {
		[self->_delgate didSelectAnnotation: sender];	
	}
}

@end
