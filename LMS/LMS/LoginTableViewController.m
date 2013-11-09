//
//  ABLoginTableViewController.m
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LoginTableViewController.h"
#import "UITextField+Extended.h"

//#import "LROAuth2Client.h"
//#import "LROAuth2AccessToken.h"

#import "PopUpLoginView.h"

#import "AppDelegate.h"
//#import "Reachability.h"

//#import "ABActivityViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Parameters.h"

#import <FacebookSDK/FacebookSDK.h>

static NSString* const keyHideKeyboard = @"hideKeyboard";
static NSString* const keyLoginResult = @"loginResult";

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

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
	
	UIColor *color = [UIColor colorFromHexString:((AppDelegate *)[AppDelegate appDelegate]).appParameters.parameters.color];
	self.loginButton.color = color;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:keyHideKeyboard object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:keyLoginResult object:nil];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:keyNetworkStatusChanged object:nil];
	
	[self setupSessionManager];
	[self setupStyle];
	
	self.loginTextField.nextTextField = self.passwordTextField;
	self.passwordTextField.nextTextField = nil;
	
	//INFO: hide keyboard
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)setupSessionManager {
	/*
	ABAppDelegate *appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
	//TODO: setup session manager [OK]
	[appDelegate.sessionManager setupSessionWithClientID:@"B87FB020-B37C-439F-B29F-3111DD016DD8" secret:@"5C4134BE-9F7A-4FA5-8548-E601CF2FD970" redirectURL:[NSURL URLWithString:@"http://api.bloc.net/testtool/oauth2tools.aspx"]];
	appDelegate.sessionManager.delegate = self;
	[appDelegate.sessionManager setUserURL:[NSURL URLWithString:@"http://nbif.aktivbedrift.no/OAuth/Authorize"]];
	[appDelegate.sessionManager setTokenURL:[NSURL URLWithString:@"http://nbif.aktivbedrift.no/OAuth/Token"]];
	 */
}

- (void)setupStyle {
	
	//INFO: Background
	//	Default@2x.png
	UIImage *backgroundImage = [UIImage imageNamed:@"Background"];
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
	
/*	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:backgroundView
																  attribute:NSLayoutAttributeLeading
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.view.superview
																  attribute:NSLayoutAttributeLeading
																 multiplier:1
																   constant:100];
	
	[backgroundView addConstraint:constraint];
	*/
	
	[self.tableView setBackgroundView:backgroundView];
	
	//INFO: Password TextField
	self.passwordTextField.borderStyle = UITextBorderStyleNone;
	
	self.passwordTextField.layer.masksToBounds = YES;
	self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
	self.passwordTextField.font = [UIFont defaultFont];
	
	[[self.passwordTextField layer] setBorderColor:[[UIColor colorWithRed:0/255.0 green:126.0/255.0 blue:181.0/255.0 alpha:1.0] CGColor]];
	
	//INFO: Login TextField
	self.loginTextField.borderStyle = UITextBorderStyleNone;
	
	self.loginTextField.layer.masksToBounds = YES;
	self.loginTextField.backgroundColor = [UIColor whiteColor];
    self.loginTextField.layer.borderWidth = 1.0f;
	self.loginTextField.font = [UIFont defaultFont];
	
	[[self.loginTextField layer] setBorderColor:[[UIColor colorWithRed:0/255.0 green:126.0/255.0 blue:181.0/255.0 alpha:1.0] CGColor]];
}

#warning HARD FIX DONE HERE
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
		
	/*
	 self.loginAcivityIndicator.hidden = YES;
	 self.loginButton.hidden = NO;
	 [self.loginAcivityIndicator stopAnimating];
	 */
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyHideKeyboard object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyLoginResult object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyNetworkStatusChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"login"]) {
#ifdef DEBUG
		NSLog(@"login: %@ - password: %@", self.loginTextField.text, self.passwordTextField.text);
#endif
	}
}

#pragma mark - TextFields delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	UITextField *next = textField.nextTextField;
	if (next) {
		[next becomeFirstResponder];
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:0 animated:YES];
	} else {
		[textField resignFirstResponder];
		if (textField == self.passwordTextField)
			[self loginButton:nil];
	}
	//INFO: We do not want UITextField to insert line-breaks
	return NO;
}

#pragma mark - NSNotification - Hide Keyaboard

- (void)hideKeyboard:(NSNotification *)notification {
	if ([self.loginTextField isFirstResponder])
		[self.loginTextField resignFirstResponder];
	else if ([self.passwordTextField isFirstResponder])
		[self.passwordTextField resignFirstResponder];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}

#pragma mark - login

- (IBAction)loginButton:(id)sender {
//	ABAppDelegate *appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
	/*
	if (self.appDelegate.connectionManager.hostActive == NO) {
		[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
		return;
	}
	 */
	if ([self.loginTextField.text length] > 0 &&
		[self.passwordTextField.text length] > 0) {
		//TODO: do the login --> if success performSegueWithIdentifier
		
		/*
		 self.loginAcivityIndicator.hidden = NO;
		 self.loginButton.hidden = YES;
		 [self.loginAcivityIndicator startAnimating];
		 */
		
		[self setupSessionManager];
		/*
		if (![self.view.superview.subviews containsObject:self.popupLoginView]) {
			
			//[self.appDelegate.sessionManager setLogin:self.loginTextField.text andPassword:self.passwordTextField.text];
			//
			NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.popupLoginView
																		  attribute:NSLayoutAttributeLeading
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self.popupLoginView.superview
																		  attribute:NSLayoutAttributeLeading
																		 multiplier:1
																		   constant:100];

			[self.popupLoginView addConstraint:constraint];
			[self.view.superview addSubview:self.popupLoginView];
			[self.view.superview layoutSubviews];
		}
		 */
		//
		
		/*
		self.popupLoginView.alpha = 0.0;
		self.popupLoginView.hidden = NO;

		[UIView animateWithDuration:0.8
						 animations:^{
							 self.popupLoginView.alpha = 1.0;
						 } completion:^(BOOL finished) {
//							 [appDelegate.sessionManager setLogin:self.loginTextField.text andPassword:self.passwordTextField.text];
//							 [appDelegate.sessionManager authorizeUsingPopupLoginView:self.popupLoginView];
						 }];
		 */
		[self loadRootViewController];
	}
	else {
		//TODO: display error
	}
	//INFO: debug
}

#pragma mark - tableview

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Message Error

- (void)displayError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bad login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	self.loginAcivityIndicator.hidden = YES;
	self.loginButton.hidden = NO;
	[self.loginAcivityIndicator stopAnimating];
}

- (void)displayNetworkError {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No network" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	self.loginAcivityIndicator.hidden = YES;
	self.loginButton.hidden = NO;
	[self.loginAcivityIndicator stopAnimating];
}

#pragma mark OAuth2

#pragma mark - Session Manager

- (void)loginResult:(NSNotification *)notification {
	//INFO: old way to be notify
}

- (void)networkStatusChanged:(NSNotification *)notification {
//	ABAppDelegate *appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
	/*
	if (appDelegate.connectionManager.hostActive == NO) {
#ifdef DEBUG
		NSLog(@"Host unavailable");
#endif
		self.loginAcivityIndicator.hidden = YES;
		self.popupLoginView.hidden = YES;
		self.loginButton.hidden = NO;
		[self.loginAcivityIndicator stopAnimating];
		
		[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
	}
	 */
}


#pragma mark - ABSessionDelegate

- (void)loadRootViewController {
	[self performSegueWithIdentifier:@"rootSegue" sender:self];
}

- (void)didReceiveBadToken {
	[self performSelectorOnMainThread:@selector(displayError) withObject:nil waitUntilDone:NO];
}

- (void)didGetWebViewError:(NSError *)error {
	self.popupLoginView.hidden = YES;
	//	[self.popupLoginView removeFromSuperview];
	//[self.popupLoginView removeFromSuperview];
	if (error.code == -1004 || error.code == -1003) {
		[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
	}
	
	
}

@end
