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
#import "ConventionTools.h"

#import "LMSMapCollectionViewCell.h"

@interface LMSMapView ()

@property (nonatomic, strong) NSMutableArray *selectedOptions;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

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
	self.locationsRecordList = [[NSMutableArray alloc] init];
	
	self.delegate = self;
	[self setShowsUserLocation:YES];
	
	[self.selectedOptions addObject:[NSNumber numberWithInt:LMSMapRoute]];
	[self.selectedOptions addObject:[NSNumber numberWithInt:LMSMapPins]];
	//	[self.selectedOptions addObject:[NSNumber numberWithInt:LMSMapHistory]];
	
	//
	
	self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.closeButton addTarget:self
						 action:@selector(aMethod:)
			   forControlEvents:UIControlEventTouchDown];
	[self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
	self.closeButton.frame = CGRectMake(10.0, 10.0, 40.0, 30.0);
	self.closeButton.alpha = 0;
	self.closeButton.tintColor = [UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
	
	
	
	[self addSubview:self.closeButton];
	
	
}

- (void)addCloseButton {
	
	[UIView animateWithDuration:0.6
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
						 self.closeButton.alpha = 1;
                     }
                     completion:^(BOOL finished1) {
						 self.closeButton.hidden = NO;
					 }];
}

- (void)removeCloseButton {
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
						 self.closeButton.alpha = 0;
                     }
                     completion:^(BOOL finished1) {
						 self.closeButton.hidden = YES;
					 }];
}

- (void)aMethod:(UIButton*)button {
	if ([self.mapViewDelegate respondsToSelector:@selector(closeMapButtonHandler)]) {
		[self removeCloseButton];
		[self.mapViewDelegate closeMapButtonHandler];
	}
}

- (void)initRegionWithStartLocationRecord:(LocationRecord *)startLocationRecord andEndLocationRecord:(LocationRecord *)endLocationRecord {
	
	[startLocationRecord debug];
	[endLocationRecord debug];
	
	//	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([endLocationRecord.latitude floatValue], [endLocationRecord.longitude floatValue]);
	
	//	[self setCenterCoordinate:centerCoordinate animated:YES];
	
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [endLocationRecord.latitude floatValue];
    region.center.longitude = [endLocationRecord.longitude floatValue];
    region.span.longitudeDelta = 0.0015f;
    region.span.latitudeDelta = 0.0015f;
    [self setRegion:region animated:YES];
	
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
        annotation.title = [NSString stringWithFormat:@"lat: %@ - long: %@", locationRecord.latitude, locationRecord.longitude];
        annotation.type = PVAttractionDefault;
        annotation.subtitle = [ConventionTools getDiffTimeInStringFromDate:locationRecord.updatedAt];
        [self addAnnotation:annotation];
	}
	
}

- (void)addHistory {
	//INFO: all last position known by all the stickers
	
	NSLog(@"%s", __PRETTY_FUNCTION__);
	//	LocationRecord *locationRecord = [self.locationsRecordList lastObject];
	for (LocationRecord *locationRecord in self.locationsRecordList) {
		if (locationRecord) {
			[locationRecord debug];
			
			LMSAnnotation *annotation = [[LMSAnnotation alloc] init];
			
			annotation.coordinate = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
			annotation.title = [NSString stringWithFormat:@"lat: %@ - long: %@", locationRecord.latitude, locationRecord.longitude];
			annotation.type = PVAttractionDefault;
			annotation.subtitle = [ConventionTools getDiffTimeInStringFromDate:locationRecord.updatedAt];
			[self addAnnotation:annotation];
		}
	}
}

- (void)addRoute {
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.locationsRecordList);
	
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
	
	//
	[_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	//
	if ([self.locationsRecordList count] > 0) {
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
				case LMSMapHistory:
					[self addHistory];
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

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	LMSMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCollection" forIndexPath:indexPath];
	
	cell.titleLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%s | indexPath.row: %d", __PRETTY_FUNCTION__, indexPath.row);
	_currentIndexPath = indexPath;
	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
/*
 -(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 //    UIImage *image;
 //    int row = [indexPath row];
 
 //	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCollection" forIndexPath:indexPath];
 //	cell.backgroundColor = [UIColor darkGrayColor];
 //    image = [UIImage imageNamed:_carImages[row]];
 
 CGSize size;
 BOOL isSelected = [self.currentIndexPath isEqual:indexPath];
 
 if (isSelected == YES) {
 size = CGSizeMake(90.0, 60.0);
 }
 else {
 size = CGSizeMake(70.0, 40.0);
 }
 return size;//cell.frame.size;//image.size;
 }
 */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 42;
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
