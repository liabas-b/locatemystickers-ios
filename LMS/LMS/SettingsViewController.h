//
//  SettingsViewController.h
//  LMS
//
//  Created by Adrien Guffens on 3/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OptionsRecord.h"
#import "LMSTableViewController.h"

@interface SettingsViewController : LMSTableViewController

//@property(nonatomic, strong) OptionsRecord *optionsRecord;

@property (strong, nonatomic) IBOutlet UIView *fbLoginView;

@property (strong, nonatomic) IBOutlet UISwitch *locatePhoneEnabledSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *displayFollowedStickersEnabledSwitch;

- (IBAction)handleDisplayFollowedStickersEnabled:(id)sender;
- (IBAction)handleLocatePhoneEnabled:(id)sender;

@end
