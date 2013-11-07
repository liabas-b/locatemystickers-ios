//
//  LMSMapViewController.h
//  LMS
//
//  Created by Adrien Guffens on 02/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSHeaderMapViewDelegate.h"
#import <REFrostedViewController.h>


@class LMSHeaderMapView;
@class LMSMapView;

@interface LMSMapViewController : UIViewController <LMSHeaderMapViewDelegate>

@property (strong, nonatomic) IBOutlet LMSHeaderMapView *headerMapView;
@property (strong, nonatomic) IBOutlet LMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *stickerListContainer;
@property (strong, nonatomic) IBOutlet UIView *friendListContainer;

@end
