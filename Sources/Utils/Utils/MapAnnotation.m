//
//  AdoptingAnAnnotation.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize type = _type;
@synthesize pinImage = _pinImage;
@synthesize leftIconView = _leftIconView;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle latitude:(double)latitude longitude:(double)longitude
			   type:(NSString *)type pinImage:(NSString *)pinImage andLeftIconView:(NSString *)leftIconView{
	self = [super init];
	if (self) {
		self->_title = title;
		self->_subtitle = subtitle;
		self->_coordinate.latitude = latitude;//43.727538;
		self->_coordinate.longitude = longitude;//7.415557;
		//		self->_coordinate = coordinate;
		self->_type = type;
		self->_pinImage = pinImage;
		self->_leftIconView = leftIconView;
	}
	return self;
}

@end

