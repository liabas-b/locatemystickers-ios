//
//  StickerEditingViewController.m
//  LMS
//
//  Created by Adrien Guffens on 10/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerEditingViewController.h"
#import "AppDelegate.h"
#import "LMSStickerConfiguration.h"
#import "LMSStickerConfiguration+Manager.h"
//#import "StickerConfigurationRecord.h"
//#import "StickerConfigurationRecord+Manager.h"
#import "UIViewController+Extension.h"


@interface StickerEditingViewController ()

@end

@implementation StickerEditingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self configure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerUpdateStickerConfigurationRecord:) name:keyUpdateStickerConfigurationRecord object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyUpdateStickerConfigurationRecord object:nil];
}


- (void)configure {
	//INFO: notification
	[self configureMenuLeftButtonWithBackButon:YES];
	
	UIColor *lmsColor = [UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
	
	[self.finishedButton setType:BButtonTypeDefault];
	[self.finishedButton setColor:lmsColor];
	
	[self.updateFrequencySlider setTintColor:lmsColor];
	[self updateFrequencySliderChangedHandler:self.updateFrequencySlider];
	
	[self bindView];
	
}

#pragma mark - View

- (void)bindView {
	if (self.stickerConfiguration != nil) {
		self.updateFrequencySlider.value = [self.stickerConfiguration.frequencyUpdate intValue];
		self.isActivatedSwitch.on = [self.stickerConfiguration.activate boolValue];
		
	}
}

- (void)unBindView {
	if (self.stickerConfiguration != nil) {
		self.stickerConfiguration.frequencyUpdate = @(self.updateFrequencySlider.value);
		self.stickerConfiguration.activate = @(self.isActivatedSwitch.on);
	}
}

#pragma mark - Handlers

- (IBAction)updateFrequencySliderChangedHandler:(id)sender {
	if ([sender isEqual:self.updateFrequencySlider]) {
		NSString *updateFrequencyText = [NSString stringWithFormat:@"%0.f secondes", self.updateFrequencySlider.value];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.updateFrenquencyLabel.text = updateFrequencyText;
		});
		
	}
}

- (IBAction)handleFinishedButton:(id)sender {
	[self unBindView];
	
	if (self.stickerConfiguration != nil) {
//		[[AppDelegate appDelegate].stickerManager updateStickerConfigurationRecord:self.stickerConfigurationRecord];
	}
}

- (void)handlerUpdateStickerConfigurationRecord:(NSNotification *)notification {
	
	if ([notification object] != nil) {
		NSLog(@"%s", __PRETTY_FUNCTION__);
		/*
		self.stickerConfigurationRecord = [notification object];

		NSLog(@"%s | %@", __PRETTY_FUNCTION__, [_stickerConfigurationRecord description]);
*/
	}
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

@end
