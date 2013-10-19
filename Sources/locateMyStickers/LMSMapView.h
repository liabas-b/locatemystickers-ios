//
//  LMSMapView.h
//  LMS
//
//  Created by Adrien Guffens on 4/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LMSMapViewProtocol.h"
#import "StickerSelectionCollectionView.h"

@class LocationRecord;
@class StickerRecord;

typedef enum {
	LMSMapBoundary,
    LMSMapOverlay,
    LMSMapPins,
	LMSMapHistory,
    LMSMapCharacterLocation,
    LMSMapRoute
} LMSMapOption;

@interface LMSMapView : MKMapView <MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, assign)BOOL isDisplayingStickerList;
//
@property (nonatomic, strong)NSMutableArray *locationsRecordList;
@property (nonatomic, strong)NSMutableArray *stickerRecordList;

@property (nonatomic, strong)StickerRecord *currentStickerRecord;

@property (nonatomic, strong)id<LMSMapViewProtocol> mapViewDelegate;

@property (nonatomic, strong) IBOutlet StickerSelectionCollectionView *stickerSelectionCollectionView;

- (void)loadSelectedOptions;
- (void)addCloseButton;

//

- (void)loadStickerList:(NSArray *)stickerList;
- (void)loadSticker:(StickerRecord *)stickerRecord;

@end
