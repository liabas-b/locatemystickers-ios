//
//  StickerDetailViewController.h
//  LMS
//
//  Created by Adrien Guffens on 3/1/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface StickerDetailViewController : UITableViewController <MKMapViewDelegate>

//INFO: First row
@property (strong, nonatomic) IBOutlet UIImageView *activatedImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

//INFO: Second row
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) IBOutlet UILabel *updatedAtLabel;

//INFO: Last row
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
