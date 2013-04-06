//
//  MapAnnotation.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject  <MKAnnotation> {	
	CLLocationCoordinate2D	_coordinate;
	NSString *_title;
	NSString *_subtitle;
	NSString *_type;
	NSString *_pinImage;
	NSString *_leftIconView;
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle latitude:(double)latitude longitude:(double)longitude
			   type:(NSString *)type pinImage:(NSString *)pinImage andLeftIconView:(NSString *)leftIconView;

@property(nonatomic, assign)CLLocationCoordinate2D coordinate;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subtitle;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *pinImage;
@property(nonatomic, copy)NSString *leftIconView;

@end