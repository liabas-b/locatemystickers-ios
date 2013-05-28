//
//  LMSMapView.m
//  LMS
//
//  Created by Adrien Guffens on 4/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapView.h"
#import "LocationRecord.h"

#import "LMSAnnotation.h"
#import "LMSAnnotationView.h"

#import "LocAnnotation.h"

@interface LMSMapView ()

@property (nonatomic, strong) NSMutableArray *selectedOptions;

@end

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
	
	self.selectedOptions = [[NSMutableArray alloc] init];
	self.delegate = self;
	[self setShowsUserLocation:YES];
	
	[self.selectedOptions addObject:[NSNumber numberWithInt:LMSMapRoute]];
	[self.selectedOptions addObject:[NSNumber numberWithInt:LMSMapPins]];
}

- (void)initRegionWithStartLocationRecord:(LocationRecord *)startLocationRecord andEndLocationRecord:(LocationRecord *)endLocationRecord {
	CLLocationDegrees latDelta = [startLocationRecord.latitude floatValue] - [endLocationRecord.latitude floatValue];//INFO: should be the top left and bottom right
    
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabsf(latDelta), 0.0);
    
	CLLocationCoordinate2D midCoordinate = CLLocationCoordinate2DMake([startLocationRecord.latitude floatValue], [startLocationRecord.longitude floatValue]);
	
    MKCoordinateRegion region = MKCoordinateRegionMake(midCoordinate, span);
    
    self.region = region;
	
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
		
        polylineView.lineWidth = 0;
        polylineView.strokeColor = [[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0] colorWithAlphaComponent:0.8];
        polylineView.lineJoin = kCGLineJoinRound;
        polylineView.lineCap = kCGLineCapRound;
		
        return polylineView;
    }
    else {
        return nil;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[LMSAnnotation class]]) {
		LMSAnnotationView *annotationView = [[LMSAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Sticker"];
		annotationView.canShowCallout = YES;
		return annotationView;
	}
	return nil;
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - map options

- (void)addOverlay {
	// PVParkMapOverlay *overlay = [[PVParkMapOverlay alloc] initWithPark:self.park];
    //[self.mapView addOverlay:overlay];
}

- (void)addLMSPins {
	
	NSLog(@"%s", __PRETTY_FUNCTION__);
	LocationRecord *locationRecord = [self.locationsRecordList lastObject];
	//    for (LocationRecord *locationRecord in self.locationsRecordList) {
	if (locationRecord) {
		[locationRecord debug];
		
        LMSAnnotation *annotation = [[LMSAnnotation alloc] init];
		
        annotation.coordinate = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
        annotation.title = [[locationRecord latitude] description];//attraction[@"name"];
        annotation.type = PVAttractionDefault;//[attraction[@"type"] integerValue];
        annotation.subtitle = [[locationRecord idLocation] description];//attraction[@"subtitle"];
        [self addAnnotation:annotation];
	}
	//    }
	
}

- (void)addRoute {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	LocationRecord *firstLocationRecord = self.locationsRecordList[0];
	LocationRecord *lastLocationRecord = [self.locationsRecordList lastObject];
	
	if (firstLocationRecord && lastLocationRecord) {
		[self initRegionWithStartLocationRecord:firstLocationRecord andEndLocationRecord:lastLocationRecord];
	}
	NSInteger pointsCount = [self.locationsRecordList count];
	
    CLLocationCoordinate2D pointsToUse[pointsCount];
	int i = 0;
	for (LocationRecord *locationRecord in self.locationsRecordList) {
		[locationRecord debug];
		pointsToUse[i++] = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
	}
    
	if (i > 0) {
		MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
		
		[self addOverlay:myPolyline];
	}
}

- (void)addBoundary {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	//    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:self.park.boundary
	// count:self.park.boundaryPointsCount];
	//    [self.mapView addOverlay:polygon];
}

- (void)addCharacterLocation {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	/*
	 NSString *batmanFilePath = [[NSBundle mainBundle] pathForResource:@"BatmanLocations" ofType:@"plist"];
	 NSArray *batmanLocations = [NSArray arrayWithContentsOfFile:batmanFilePath];
	 CGPoint batmanPoint = CGPointFromString(batmanLocations[rand()%4]);
	 PVCharacter *batman = (PVCharacter *)[PVCharacter circleWithCenterCoordinate:CLLocationCoordinate2DMake(batmanPoint.x, batmanPoint.y)
	 radius:MAX(5, rand()%40)];
	 batman.color = [UIColor blueColor];
	 
	 NSString *tazFilePath = [[NSBundle mainBundle] pathForResource:@"TazLocations" ofType:@"plist"];
	 NSArray *tazLocations = [NSArray arrayWithContentsOfFile:tazFilePath];
	 CGPoint tazPoint = CGPointFromString(tazLocations[rand()%4]);
	 PVCharacter *taz = (PVCharacter *)[PVCharacter circleWithCenterCoordinate:CLLocationCoordinate2DMake(tazPoint.x, tazPoint.y)
	 radius:MAX(5, rand()%40)];
	 taz.color = [UIColor orangeColor];
	 
	 NSString *tweetyFilePath = [[NSBundle mainBundle] pathForResource:@"TweetyBirdLocations" ofType:@"plist"];
	 NSArray *tweetyLocations = [NSArray arrayWithContentsOfFile:tweetyFilePath];
	 CGPoint tweetyPoint = CGPointFromString(tweetyLocations[rand()%4]);
	 PVCharacter *tweety = (PVCharacter *)[PVCharacter circleWithCenterCoordinate:CLLocationCoordinate2DMake(tweetyPoint.x, tweetyPoint.y)
	 radius:MAX(5, rand()%40)];
	 tweety.color = [UIColor yellowColor];
	 
	 [self.mapView addOverlay:batman];
	 [self.mapView addOverlay:taz];
	 [self.mapView addOverlay:tweety];
	 */
}

- (void)loadSelectedOptions {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
    [self removeAnnotations:self.annotations];
    [self removeOverlays:self.overlays];
	
	
    for (NSNumber *option in self.selectedOptions) {
        switch ([option integerValue]) {
				
            case LMSMapOverlay:
                [self addOverlay];
                break;
            case LMSMapPins:
                [self addLMSPins];
                break;
            case LMSMapRoute:
                [self addRoute];
                break;
            case LMSMapBoundary:
                [self addBoundary];
                break;
            case LMSMapCharacterLocation:
                [self addCharacterLocation];
                break;
            default:
                break;
        }
    }
	
}

- (IBAction)mapTypeChanged:(id)sender {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	/*
	 switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
	 case 0:
	 self.mapView.mapType = MKMapTypeStandard;
	 break;
	 case 1:
	 self.mapView.mapType = MKMapTypeHybrid;
	 break;
	 case 2:
	 self.mapView.mapType = MKMapTypeSatellite;
	 break;
	 default:
	 break;
	 }
	 */
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
