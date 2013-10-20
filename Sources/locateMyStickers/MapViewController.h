//
//  MapViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LMSMapView.h"


@class StickerRecord;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet LMSMapView *mapView;
@property (nonatomic, strong)StickerRecord *stickerRecord;
//@property (nonatomic, strong)NSMutableArray *locationsRecordList;


@end
