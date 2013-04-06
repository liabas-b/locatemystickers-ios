//
//  StickerAddingTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerAddingTableViewController.h"
#import "UITextField+Extended.h"

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
	
	//INFO: hide keyboard
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	
	self.nameTextField.text = self.result;
}

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
#warning To implement
	//TODO: - add the sticker to DB (may be need id)
	//      - POST to the web service
	//      - GET the id
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
