//
//  StickerDetailViewController.h
//  LMS
//
//  Created by Adrien Guffens on 3/1/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LMSMapView.h"

@class StickerRecord;

@interface StickerDetailViewController : UITableViewController <MKMapViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) StickerRecord *stickerRecord;

//INFO: First row
@property (strong, nonatomic) IBOutlet UIImageView *activatedImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UISwitch *enableSwitch;

//INFO: Second row
@property (strong, nonatomic) IBOutlet LMSMapView *mapView;

//INFO: Third row
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) IBOutlet UILabel *updatedAtLabel;

//INFO: Last row

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;


@end
