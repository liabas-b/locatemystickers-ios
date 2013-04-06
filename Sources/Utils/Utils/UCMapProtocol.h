//
//  UCMapProtocol.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKUserLocation;
@class MKMapView;
@class MKAnnotationView;

@protocol UCMapProtocol <NSObject>

@optional
- (void)didSelectAnnotation:(id)sender;

@end
