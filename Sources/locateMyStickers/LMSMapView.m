//
//  LMSMapView.m
//  LMS
//
//  Created by Adrien Guffens on 4/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapView.h"
#import "LocationRecord.h"

@implementation LMSMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.delegate = self;
}

- (void)updateLocations {
	
	
	/*MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50, 50);
	 
	 if (region.center.longitude == -180.00000000)
	 return;
	 
	 
	 [self.mapView setRegion:region animated:NO];
	 */
	BOOL startExist = NO;
	for (LocationRecord *locationRecord in self.locationsRecordList) {
		CLLocationCoordinate2D startCoordinate;
		CLLocationCoordinate2D endCoordinate;
		
		if (startExist == NO) {
			startCoordinate = CLLocationCoordinate2DMake([locationRecord.longitude floatValue], [locationRecord.latitude floatValue]);
			startExist = YES;
		}
		else {
			endCoordinate = CLLocationCoordinate2DMake([locationRecord.longitude floatValue], [locationRecord.latitude floatValue]);;
			
			
			MKMapPoint points[2] = {MKMapPointForCoordinate(startCoordinate), MKMapPointForCoordinate(endCoordinate)};
			MKPolyline* polyline = [MKPolyline polylineWithPoints:points count:2];
			[self addOverlay:polyline];
			
			startCoordinate = endCoordinate;
			
		}
	}
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
		
        polylineView.lineWidth = 0;
        polylineView.strokeColor = [[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0] colorWithAlphaComponent:1];
        polylineView.lineJoin = kCGLineJoinRound;
        polylineView.lineCap = kCGLineCapRound;
		
        return polylineView;
    }
    else {
        return nil;
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
