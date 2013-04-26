//
//  LMSMapView.h
//  LMS
//
//  Created by Adrien Guffens on 4/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <MapKit/MapKit.h>

@class LocationRecord;
@class StickerRecord;

typedef enum {
	LMSMapBoundary,
    LMSMapOverlay,
    LMSMapPins,
    LMSMapCharacterLocation,
    LMSMapRoute
} LMSMapOption;

@interface LMSMapView : MKMapView <MKMapViewDelegate>

@property (nonatomic, strong)NSMutableArray *locationsRecordList;
@property (nonatomic, strong)NSMutableArray *stickerRecordList;

@property (nonatomic, strong)StickerRecord *currentStickerRecord;

- (void)loadSelectedOptions;

@end
