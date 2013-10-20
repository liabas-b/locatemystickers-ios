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

#import "StickerRecord.h"

#import "LMSMapCollectionViewCell.h"

#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"
#import "LocationRecord+Manager.h"

#import "UIFont+AppFont.h"
#import "UIColor+AppColor.h"

@interface LMSMapView ()

@property (nonatomic, strong) NSMutableArray *selectedOptions;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

static double kHeightStickerSelectionCollectionView = 60.0;

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
	
	[self.selectedOptions addObject:@(LMSMapHistory)];
	[self.selectedOptions addObject:@(LMSMapLastLocation)];
	
	[self configureView];
}

- (void)configureView {
	self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.closeButton addTarget:self
						 action:@selector(closeMapButtonHandler:)
			   forControlEvents:UIControlEventTouchDown];
	[self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
	self.closeButton.frame = CGRectMake(10.0, 10.0, 40.0, 30.0);
	self.closeButton.alpha = 0;
	self.closeButton.tintColor = [UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
	
	[self addSubview:self.closeButton];
	
	[self updateToolBar];
}

- (void)updateToolBar {
	[self.liveToogleButton setSelected:NO];
	[self.historyToogleButton setSelected:NO];
	[self.lastLocationToogleButton setSelected:NO];
	
	NSLog(@"%s | self.selectedOptions: %@", __PRETTY_FUNCTION__, self.selectedOptions);
	
	for (NSNumber *mapOption in self.selectedOptions) {
		NSLog(@"%s | mapOption: %@", __PRETTY_FUNCTION__, mapOption);
		switch ([mapOption intValue]) {
				
			case LMSMapLive:
			{
				[self.liveToogleButton setSelected:YES];
			}
				break;
			case LMSMapLastLocation:
			{
				[self.lastLocationToogleButton setSelected:YES];
			}
				break;
			case LMSMapHistory:
			{
				[self.historyToogleButton setSelected:YES];
			}
				break;
			default:
				break;
		}
	}
}

- (void)addCloseButton {
	
	[UIView animateWithDuration:0.6
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
						 self.closeButton.alpha = 1;
						 self.closeButton.hidden = NO;
                     }
                     completion:^(BOOL finished1) {
						 
					 }];
}

- (void)removeCloseButton {
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
						 self.closeButton.alpha = 0;
						 self.closeButton.hidden = YES;
						 
                     }
                     completion:^(BOOL finished1) {
					 }];
}

- (void)closeMapButtonHandler:(UIButton*)button {
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

#pragma mark - map options for ONE

- (void)addLMSPinForSticker:(StickerRecord *)stickerRecord {
	
	NSLog(@"%s | stickerId: %@", __PRETTY_FUNCTION__, stickerRecord.stickerId);
	
	NSArray *locationsRecordList = [LocationRecord findByAttribute:@"idSticker" withValue:stickerRecord.stickerId andOrderBy:@"createdAt" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
	
	NSLog(@"%s | locationsRecordList:%@", __PRETTY_FUNCTION__, locationsRecordList);
	
	LocationRecord *locationRecord = [locationsRecordList firstObject];
	if (locationRecord) {
		[locationRecord debug];
		
        LMSAnnotation *annotation = [[LMSAnnotation alloc] init];
		
        annotation.coordinate = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
        annotation.title = [NSString stringWithFormat:@"lat: %@ - long: %@", locationRecord.latitude, locationRecord.longitude];
        annotation.type = PVAttractionDefault;
        annotation.subtitle = [ConventionTools getDiffTimeInStringFromDate:locationRecord.updatedAt];
        [self addAnnotation:annotation];
		
		[self zoomToLocation:locationRecord];
	}
	else {
		//TODO: update location list
		self.currentStickerRecord = stickerRecord;
		[self updateLocationRecords];
		//		[self updateLocationForCurrentSticker];
	}
	
}

- (void)addHistoryForSticker:(StickerRecord *)stickerRecord {
	//INFO: all last position known by all the stickers
	
	NSArray *locationsRecordList = [LocationRecord findByAttribute:@"idSticker" withValue:stickerRecord.stickerId andOrderBy:@"createdAt" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
	
	NSLog(@"%s | locationsRecordList:%@", __PRETTY_FUNCTION__, locationsRecordList);
	//	LocationRecord *locationRecord = [self.locationsRecordList lastObject];
	for (LocationRecord *locationRecord in locationsRecordList) {
		if (locationRecord) {
			[locationRecord debug];
			
			LMSAnnotation *annotation = [[LMSAnnotation alloc] init];
			
			NSLog(@"%s | lat: %@ - long: %@", __PRETTY_FUNCTION__, locationRecord.latitude, locationRecord.longitude);
			
			annotation.coordinate = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
			annotation.title = [NSString stringWithFormat:@"lat: %@ - long: %@", locationRecord.latitude, locationRecord.longitude];
			annotation.type = PVAttractionDefault;
			annotation.subtitle = [ConventionTools getDiffTimeInStringFromDate:locationRecord.updatedAt];
			[self addAnnotation:annotation];
		}
	}
}

- (void)addRouteForSticker:(StickerRecord *)stickerRecord {
	NSArray *locationsRecordList = [LocationRecord findByAttribute:@"idSticker" withValue:stickerRecord.stickerId andOrderBy:@"createdAt" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
	
	NSLog(@"%s | locationsRecordList:%@", __PRETTY_FUNCTION__, locationsRecordList);
	
	if ([locationsRecordList count] < 2)
		return;
	
	LocationRecord *firstLocationRecord = locationsRecordList[0];
	LocationRecord *lastLocationRecord = [locationsRecordList lastObject];
	
	
	
	if (firstLocationRecord && lastLocationRecord) {
		if (!([firstLocationRecord.latitude isEqual:lastLocationRecord.latitude] && [firstLocationRecord.longitude isEqual:lastLocationRecord.latitude]))
		{
			[self initRegionWithStartLocationRecord:firstLocationRecord andEndLocationRecord:lastLocationRecord];
		}
	}
	NSInteger pointsCount = [self.locationsRecordList count];
	LocationRecord *savLocationRecord = nil;
	
    CLLocationCoordinate2D pointsToUse[pointsCount];
	int i = 0;
	for (LocationRecord *locationRecord in locationsRecordList) {
		[locationRecord debug];
		/*		if (savLocationRecord == nil) {
		 savLocationRecord = locationRecord;
		 pointsToUse[i++] = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
		 }
		 else {
		 */
		if (!([locationRecord.latitude isEqual:savLocationRecord.latitude] && [locationRecord.longitude isEqual:savLocationRecord.latitude]))
			pointsToUse[i++] = CLLocationCoordinate2DMake([locationRecord.latitude floatValue], [locationRecord.longitude floatValue]);
		savLocationRecord = locationRecord;
		//}
	}
    
	if (i > 0) {
		MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
		
		[self addOverlay:myPolyline];
	}
}


#pragma mark - map options for ALL

- (void)addOverlay {
	// PVParkMapOverlay *overlay = [[PVParkMapOverlay alloc] initWithPark:self.park];
    //[self.mapView addOverlay:overlay];
}

- (void)addLMSPinsForStickerList {
	
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

- (void)addHistoryForStickerList {
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

- (void)addRouteForStickerList {
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

- (void)addBoundaryForStickerList {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	//    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:self.park.boundary
	// count:self.park.boundaryPointsCount];
	//    [self.mapView addOverlay:polygon];
}

- (void)addCharacterLocationForStickerList {
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

- (void)loadSticker:(StickerRecord *)stickerRecord {
	//WARNINIG: may be move it to loadStickerList
	
	if (self.isDisplayingStickerList == NO) {
		[self removeAnnotations:self.annotations];
		[self removeOverlays:self.overlays];
		self.stickerSelectionCollectionView.delegate = nil;
		
	}
	[self zoomToCurrentLocation:nil];
	
	//	[self zoomToLocation:stickerRecord.lastLocation];
	
	
	for (NSNumber *mapOption in self.selectedOptions) {
		
		switch ([mapOption intValue]) {
			case LMSMapLive:
			{
				
			}
				break;
			case LMSMapLastLocation:
			{
				[self addLMSPinForSticker:stickerRecord];
			}
				break;
			case LMSMapHistory:
			{
				[self addRouteForSticker:stickerRecord];
			}
				break;
			default:
				break;
		}
	}
}

- (void)loadStickerList:(NSArray *)stickerList {
	
	[self removeAnnotations:self.annotations];
    [self removeOverlays:self.overlays];
	
	[self.stickerRecordList removeAllObjects];
	
	self.stickerRecordList = [[NSMutableArray alloc] initWithArray:stickerList];
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, stickerList);
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self.stickerRecordList);
	
	[self.stickerSelectionCollectionView reloadData];
	
	[self selectSticker];
	
	[self zoomToCurrentLocation:nil];
	
	for (StickerRecord *stickerRecord in stickerList) {
		[self loadSticker:stickerRecord];
	}
}

- (void)selectSticker {
	if ([self.stickerRecordList count] > 1) {
		
		//
		
		//		[self.stickerSelectionCollectionView reloadData];
		
		//		NSIndexPath *selection = [NSIndexPath indexPathForItem:1 inSection:0];
		//		[self.stickerSelectionCollectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
		//
		//
		
		[_stickerSelectionCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
		
		//		LMSMapCollectionViewCell *selectedMapCollectionViewCell = (LMSMapCollectionViewCell *)[self collectionView:self.stickerSelectionCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		
		
		//		[selectedMapCollectionViewCell setSelected:YES];
		//		[self collectionView:self.stickerSelectionCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		
	}
	else {
		[self collectionView:self.stickerSelectionCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		
		[self.stickerSelectionCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
		[_stickerSelectionCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	}
}

- (void)loadSelectedOptions {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	/*
	 [self removeAnnotations:self.annotations];
	 [self removeOverlays:self.overlays];
	 
	 [_stickerSelectionCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	 //
	 if ([self.locationsRecordList count] > 0) {
	 for (NSNumber *option in self.selectedOptions) {
	 switch ([option integerValue]) {
	 
	 case LMSMapOverlay:
	 [self addOverlay];
	 break;
	 case LMSMapPins:
	 [self addLMSPinsForStickerList];
	 break;
	 case LMSMapRoute:
	 [self addRouteForStickerList];
	 break;
	 case LMSMapHistory:
	 [self addHistoryForStickerList];
	 break;
	 case LMSMapBoundary:
	 [self addBoundaryForStickerList];
	 break;
	 case LMSMapCharacterLocation:
	 [self addCharacterLocationForStickerList];
	 break;
	 default:
	 break;
	 }
	 }
	 }
	 */
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
	StickerRecord *stickerRecord = [self.stickerRecordList objectAtIndex:indexPath.row];
	
	cell.titleLabel.text = [NSString stringWithFormat:@"%@", stickerRecord.name];
	cell.defaultColor = [UIColor wheatColor];
	cell.selectedColor = [UIColor colorFromHexString:stickerRecord.color];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%s | indexPath.row: %d", __PRETTY_FUNCTION__, indexPath.row);
	_currentIndexPath = indexPath;
	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	
	StickerRecord *stickerRecord = [self.stickerRecordList objectAtIndex:indexPath.row];
	
	[self loadSticker:stickerRecord];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
	
	//StickerRecord *stickerRecord = [self.stickerRecordList objectAtIndex:indexPath.row];
	
	//[self loadSticker:stickerRecord];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	StickerRecord *stickerRecord = [self.stickerRecordList objectAtIndex:indexPath.row];
	
	CGSize namelabelSize = [stickerRecord.name sizeWithFont:[UIFont defaultFont] constrainedToSize:CGSizeMake(20000, kHeightStickerSelectionCollectionView) lineBreakMode:NSLineBreakByWordWrapping];
	
	NSLog(@"%s | %f %f", __PRETTY_FUNCTION__, namelabelSize.width, namelabelSize.height);
	if (namelabelSize.width == 0) {
		//WARNING: may be do more job
	}
	else {
		namelabelSize.height = kHeightStickerSelectionCollectionView;
		namelabelSize.width += 40.0;
	}
	return namelabelSize;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.stickerRecordList count];
}

//


- (void)updateLocationRecords {
	
	if (self.currentStickerRecord == nil)
		return;
	
	[[AppDelegate appDelegate].locationManager updateLocationRecordsForSticker:self.currentStickerRecord success:^(NSMutableDictionary *JSON) {
		
		
		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			LocationRecord *locationRecord = [LocationRecord addUpdateWithDictionary:dic];
			NSLog(@" %s| locationRecord: %@", __PRETTY_FUNCTION__, locationRecord);
		}
		if ([JSON count] > 0) {
			[self loadSticker:self.currentStickerRecord];
		}
		
	} failure:^(NSURLRequest *request, NSError *error, id JSON) {
		NSLog(@"%s | Request: %@", __PRETTY_FUNCTION__, [request description]);
		//		NSLog(@"%s | Status Code: %d", __PRETTY_FUNCTION__, [response statusCode]);
		NSLog(@"%s | JSON: %@", __PRETTY_FUNCTION__, JSON);
		
		
	}];
}

- (IBAction)zoomToCurrentLocation:(UIBarButtonItem *)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    
    MKCoordinateRegion region;
    region.center.latitude = self.userLocation.coordinate.latitude;
    region.center.longitude = self.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self setRegion:region animated:YES];
}

- (void)zoomToLocation:(LocationRecord *)locationRecord {
    float spanX = 0.00725;
    float spanY = 0.00725;
    
    MKCoordinateRegion region;
    region.center.latitude = [locationRecord.latitude doubleValue];
    region.center.longitude = [locationRecord.longitude doubleValue];
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self setRegion:region animated:YES];
}



- (IBAction)liveButtonHandler:(id)sender {
	
	NSLog(@"%s | self.selectedOptions: %@", __PRETTY_FUNCTION__, self.selectedOptions);
	
	if ([self.selectedOptions containsObject:@(LMSMapLive)]) {
		[self.selectedOptions removeObject:@(LMSMapLive)];
	}
	else {
		[self.selectedOptions addObject:@(LMSMapLive)];
	}
	[self updateToolBar];
	[self loadSticker:self.currentStickerRecord];
}

- (IBAction)historyButtonHandler:(id)sender {
	NSLog(@"%s | self.selectedOptions: %@", __PRETTY_FUNCTION__, self.selectedOptions);
	
	if ([self.selectedOptions containsObject:@(LMSMapHistory)]) {
		[self.selectedOptions removeObject:@(LMSMapHistory)];
	}
	else {
		[self.selectedOptions addObject:@(LMSMapHistory)];
	}
	[self updateToolBar];
	[self loadSticker:self.currentStickerRecord];
}

- (IBAction)lastLocationButtonHandler:(id)sender {
	NSLog(@"%s | self.selectedOptions: %@", __PRETTY_FUNCTION__, self.selectedOptions);
	if ([self.selectedOptions containsObject:@(LMSMapLastLocation)]) {
		[self.selectedOptions removeObject:@(LMSMapLastLocation)];
	}
	else {
		[self.selectedOptions addObject:@(LMSMapLastLocation)];
	}
	
	[self updateToolBar];
	[self loadSticker:self.currentStickerRecord];
}

@end
