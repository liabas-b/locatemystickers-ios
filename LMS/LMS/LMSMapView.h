//
//  LMSMapView.h
//  LMS
//
//  Created by Adrien Guffens on 4/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LMSMapViewProtocol.h"
#import "LMSStickerCollectionView.h"

@class LMSLocation;
@class LMSSticker;

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
@property (nonatomic, strong) NSMutableArray *locationList;
@property (nonatomic, strong) NSMutableArray *stickerList;

@property (nonatomic, strong) LMSSticker *currentSticker;

@property (nonatomic, strong) id<LMSMapViewProtocol> mapViewDelegate;

@property (nonatomic, strong) IBOutlet LMSStickerCollectionView *stickerSelectionCollectionView;

- (void)loadSelectedOptions;
- (void)addCloseButton;

//

- (void)loadStickerList:(NSArray *)stickerList;
- (void)loadSticker:(LMSSticker *)sticker;

@property (strong, nonatomic) IBOutlet UIButton *liveToogleButton;
@property (strong, nonatomic) IBOutlet UIButton *historyToogleButton;
@property (strong, nonatomic) IBOutlet UIButton *lastLocationToogleButton;

- (IBAction)liveButtonHandler:(id)sender;
- (IBAction)historyButtonHandler:(id)sender;
- (IBAction)lastLocationButtonHandler:(id)sender;

@end
