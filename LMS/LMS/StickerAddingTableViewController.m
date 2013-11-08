//
//  StickerAddingTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerAddingTableViewController.h"
#import "UITextField+Extended.h"
#import "BButton.h"

//#import "OptionsRecord.h"
#import "AppParameters.h"

#import "LMSSticker.h"

//#import "StickersManager.h"
//#import "StickerRecord+Manager.h"
#import "LMSSticker+Manager.h"

//#import "LocationManager.h"
#import "AppDelegate.h"

@interface StickerAddingTableViewController ()

@end

@implementation StickerAddingTableViewController

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
	
	
	[self configure];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerAddStickerRecord:) name:keyAddStickerRecord object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyAddStickerRecord object:nil];
}

- (void)configure {
	//INFO: notification

	UIColor *lmsColor = [UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
	
	[self.finishedButton setType:BButtonTypeDefault];
	[self.finishedButton setColor:lmsColor];
	[self.nameTextField setTintColor:lmsColor];

	[self.updateFrequencySlider setTintColor:lmsColor];
	[self updateFrequencySliderChangedHandler:self.updateFrequencySlider];
	
	//INFO: hide keyboard
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	
	[self bindView];
	
}

- (void)bindView {
	if (self.sticker != nil) {
		self.nameTextField.text = self.sticker.name;

		self.descriptionTextView.text = self.sticker.text;
		if ([self.sticker.text length] > 0)
			self.descriptionLabel.hidden = YES;
		//		self.updateFrequencySlider.value = 0.42;
		
	}	
}

- (void)unBindView {
	if (self.sticker != nil) {
		self.sticker.name = self.nameTextField.text;

		self.sticker.text = self.descriptionTextView.text;
//		self.stickerRecord.labels = @"";
//		self.stickerRecord.updateFrequency = self.updateFrequencySlider.value;
	}
}

- (IBAction)updateFrequencySliderChangedHandler:(id)sender {
	if ([sender isEqual:self.updateFrequencySlider]) {
		NSString *updateFrequencyText = [NSString stringWithFormat:@"%0.f secondes", self.updateFrequencySlider.value];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.updateFrequencyLabel.text = updateFrequencyText;
		});
		
	}
}

#warning TODO: configure the view methode
//TODO: configure the view methode

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextFields delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    //NSLog(@"called");
	// [textView resignFirstResponder];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
	self.descriptionLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([self.descriptionTextView.text length] == 0)
		self.descriptionLabel.hidden = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"])
		[self.descriptionTextView resignFirstResponder];
	return YES;
}

#pragma mark - NSNotification - Hide Keyaboard

- (void)hideKeyboard:(NSNotification *)notification {
	if ([self.nameTextField isFirstResponder])
		[self.nameTextField resignFirstResponder];
	else if ([self.descriptionTextView isFirstResponder])
		[self.descriptionTextView resignFirstResponder];
	else if ([self.labelsTextField isFirstResponder])
		[self.labelsTextField resignFirstResponder];
	
	//[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}

- (IBAction)handleFinishedButton:(id)sender {
	[self unBindView];
	
	if (self.sticker != nil) {
//		[[AppDelegate appDelegate].stickerManager addStickerRecord:self.stickerRecord];
	}
}

- (void)handlerAddStickerRecord:(NSNotification *)notification {
	if ([notification object] != nil) {
		NSLog(@"%s", __PRETTY_FUNCTION__);

		self.sticker = [notification object];
/*
		if ([self.stickerRecord.stickerTypeId intValue] == StickerTypeIphone) {
			NSLog(@"%s Location phone enable", __PRETTY_FUNCTION__);
			[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
				OptionsRecord *localOptionsRecord = [[AppDelegate appDelegate].optionsRecord inContext:localContext];
				localOptionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			} completion:^{
				NSLog(@"%s saved OptionsRecord", __PRETTY_FUNCTION__);
			}];
			
#warning SAVE CONTEXT may be
			NSLog(@"%s Starting location manager", __PRETTY_FUNCTION__);
			[[AppDelegate appDelegate].locationManager startWithStickerCode:self.stickerRecord.code];
 */
//		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
