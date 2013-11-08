//
//  StickerEditingViewController.h
//  LMS
//
//  Created by Adrien Guffens on 10/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSTableViewController.h"
#import "BButton.h"

@class LMSStickerConfiguration;

@interface StickerEditingViewController : LMSTableViewController

@property (nonatomic, strong) LMSStickerConfiguration *stickerConfiguration;

@property (strong, nonatomic) IBOutlet UISwitch *isActivatedSwitch;

@property (strong, nonatomic) IBOutlet UILabel *updateFrenquencyLabel;
@property (strong, nonatomic) IBOutlet UISlider *updateFrequencySlider;

@property (strong, nonatomic) IBOutlet BButton *finishedButton;

- (IBAction)updateFrequencySliderChangedHandler:(id)sender;


@end
