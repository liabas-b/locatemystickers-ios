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
	LMSMapBoundary = 1,
    LMSMapOverlay = 2,
    LMSMapPins = 3,
	LMSMapHistory = 4,
    LMSMapCharacterLocation = 5,
    LMSMapRoute = 6,
	LMSMapLastLocation = 7,
	LMSMapLive = 8
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

@property (strong, nonatomic) IBOutlet UIButton *liveToogleButton;
@property (strong, nonatomic) IBOutlet UIButton *historyToogleButton;
@property (strong, nonatomic) IBOutlet UIButton *lastLocationToogleButton;

- (IBAction)liveButtonHandler:(id)sender;
- (IBAction)historyButtonHandler:(id)sender;
- (IBAction)lastLocationButtonHandler:(id)sender;

@end
