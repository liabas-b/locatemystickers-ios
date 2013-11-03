//
//  LMSHeaderMapView.h
//  LMS
//
//  Created by Adrien Guffens on 02/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSMapViewButton.h"
#import "LMSMapImageView.h"
#import "LMSMapBaseView.h"
#import "LMSHeaderMapViewDelegate.h"

@interface LMSHeaderMapView : UIView

@property (nonatomic, strong) IBOutlet id<LMSHeaderMapViewDelegate> delegate;
//INFO: first box
@property (nonatomic, strong) IBOutlet UILabel *appName;

//INFO: second box
@property (nonatomic, strong) IBOutlet LMSMapImageView *profileImageView;

//INFO: button boxes
@property (nonatomic, strong) IBOutlet LMSMapViewButton *stickerMapViewButton;
@property (nonatomic, strong) IBOutlet LMSMapViewButton *friendMapViewButton;

//INFO: notification
@property (nonatomic, strong) IBOutlet LMSMapBaseView *notificationView;
@property (nonatomic, strong) IBOutlet UILabel *notificationCountLabel;

@end
