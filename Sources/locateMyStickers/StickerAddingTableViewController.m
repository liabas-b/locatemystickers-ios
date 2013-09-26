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

#import "OptionsRecord.h"
#import "StickerRecord.h"

#import "StickerManager.h"
#import "LocationManager.h"
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerAddStickerRecord:) name:keyAddStickerRecord object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyAddStickerRecord object:nil];
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
	if (self.stickerRecord != nil) {
		self.nameTextField.text = self.stickerRecord.name;

		self.descriptionTextView.text = self.stickerRecord.text;
		if ([self.stickerRecord.text length] > 0)
			self.descriptionLabel.hidden = YES;
		//		self.updateFrequencySlider.value = 0.42;
		
	}	
}

- (void)unBindView {
	if (self.stickerRecord != nil) {
		self.stickerRecord.name = self.nameTextField.text;

		self.stickerRecord.text = self.descriptionTextView.text;
//		self.stickerRecord.labels = @"";
//		self.stickerRecord.updateFrequency = self.updateFrequencySlider.value;
	}
}

- (IBAction)updateFrequencySliderChangedHandler:(id)sender {
	if ([sender isEqual:self.updateFrequencySlider]) {
		NSString *updateFrequencyText = [NSString stringWithFormat:@"%0.f secondes", self.updateFrequencySlider.value * 60];
		
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
	/*	UITextField *next = textField.nextTextField;
	 if (next) {
	 [next becomeFirstResponder];
	 //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:0 animated:YES];
	 } else {
	 [textField resignFirstResponder];
	 if (textField == self.passwordTextField)
	 [self loginButton:nil];
	 }
	 //INFO: We do not want UITextField to insert line-breaks
	 return NO;*/
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
	
	if (self.stickerRecord != nil) {
		[[AppDelegate appDelegate].stickerManager addStickerRecord:self.stickerRecord];
	}
}

- (void)handlerAddStickerRecord:(NSNotification *)notification {
	if ([notification object] != nil) {
		NSLog(@"%s", __PRETTY_FUNCTION__);

		self.stickerRecord = [notification object];

		[self.stickerRecord debug];
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
		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
