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
#import "LMSViewController.h"


@class LMSHeaderMapView;
@class LMSMapView;

@interface LMSMapViewController : LMSViewController <LMSHeaderMapViewDelegate>

@property (strong, nonatomic) IBOutlet LMSHeaderMapView *headerMapView;
@property (strong, nonatomic) IBOutlet LMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *stickerListContainer;
@property (strong, nonatomic) IBOutlet UIView *friendListContainer;
//INFO: config button
@property (strong, nonatomic) IBOutlet UIButton *autoFocusButton;

@end
