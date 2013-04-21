//
//  LoginTableViewController.m
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LoginTableViewController.h"
#import "UITextField+Extended.h"
#import "BButton.h"

#import "LROAuth2Client.h"
#import "LROAuth2AccessToken.h"

#import "PopUpLoginView.h"

#import "AppDelegate.h"
#import "Reachability.h"

//#import "ABActivityViewController.h"

#import <QuartzCore/QuartzCore.h>

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
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//TODO: setup session manager [OK]

	[appDelegate.sessionManager setupSessionWithClientID:@"Vt1yS6eU28cqA6cnssKANqSNWOxsGbMr8eWdBoHh" secret:@"P287fmh0dVqPvI8S4qw5FtnZx9mPMPDxO8uK6puz" redirectURL:[NSURL URLWithString:@"http://192.168.1.100:3000/oauth/access_token"]];
	appDelegate.sessionManager.delegate = self;
	[appDelegate.sessionManager setUserURL:[NSURL URLWithString:@"http://192.168.1.100:3000/oauth/authorize"]];
	[appDelegate.sessionManager setTokenURL:[NSURL URLWithString:@"http://192.168.1.100:3000/oauth/access_token"]];


/*
 [appDelegate.sessionManager setupSessionWithClientID:@"B87FB020-B37C-439F-B29F-3111DD016DD8" secret:@"5C4134BE-9F7A-4FA5-8548-E601CF2FD970" redirectURL:[NSURL URLWithString:@"http://api.bloc.net/testtool/oauth2tools.aspx"]];
 appDelegate.sessionManager.delegate = self;
 [appDelegate.sessionManager setUserURL:[NSURL URLWithString:@"http://nbif.aktivbedrift.no/OAuth/Authorize"]];
 [appDelegate.sessionManager setTokenURL:[NSURL URLWithString:@"http://nbif.aktivbedrift.no/OAuth/Token"]];

 
 */
}

- (void)setupStyle {
	
	//INFO: Background
	//	Default@2x.png
	UIImage *backgroundImage = [UIImage imageNamed:@"BackgroundWhite"];
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
	[self.tableView setBackgroundView:backgroundView];
	
	//INFO: Password TextField
	self.passwordTextField.borderStyle = UITextBorderStyleNone;
	
	self.passwordTextField.layer.masksToBounds = YES;
	self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
	
	[[self.passwordTextField layer] setBorderColor:[[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0] CGColor]];
	
	//INFO: Login TextField
	self.loginTextField.borderStyle = UITextBorderStyleNone;
	
	self.loginTextField.layer.masksToBounds = YES;
	self.loginTextField.backgroundColor = [UIColor whiteColor];
    self.loginTextField.layer.borderWidth = 1.0f;
	
	[[self.loginTextField layer] setBorderColor:[[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0] CGColor]];
	
	//INFO: login Button
	[self.loginButton setType:BButtonTypeDefault];
	[self.loginButton setColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];
//	[self.loginButton setColor:[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate.sessionManager loadAccessToken];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:keyHideKeyboard object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:keyLoginResult object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:keyNetworkStatusChanged object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyHideKeyboard object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyLoginResult object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyNetworkStatusChanged object:nil];
}

- (void)dealloc {
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
	//INFO: to delete BEGIN
	
	[self performSelectorOnMainThread:@selector(loadActivityViewController) withObject:nil waitUntilDone:NO];
	return;

	 //END
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.connectionManager.hostActive == NO) {
		[self performSelectorOnMainThread:@selector(displayNetworkError) withObject:nil waitUntilDone:NO];
		return;
	}
	if ([self.loginTextField.text length] > 0 &&
		[self.passwordTextField.text length] > 0) {
		//TODO: do the login --> if success performSegueWithIdentifier
		
		self.loginAcivityIndicator.hidden = NO;
		self.loginButton.hidden = YES;
		[self.loginAcivityIndicator startAnimating];
		
		[self setupSessionManager];
		
		[appDelegate.sessionManager setLogin:self.loginTextField.text andPassword:self.passwordTextField.text];
		
		[self.view.superview addSubview:self.popupLoginView];
		self.popupLoginView.hidden = NO;
		[appDelegate.sessionManager authorizeUsingPopupLoginView:self.popupLoginView];
		
	}
	else {
		//TODO: display error
	}
	//INFO: debug
}

#pragma mark - Message Error

- (void)displayError {
#warning maybe bad alert message
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect login" message:@"Username or password are incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	
	self.loginAcivityIndicator.hidden = YES;
	self.loginButton.hidden = NO;
	[self.loginAcivityIndicator stopAnimating];
}

- (void)displayNetworkError {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect login" message:@"Ingen Internett-tilkobling" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
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
}


#pragma mark - ABSessionDelegate

- (void)loadActivityViewController {
	[self performSegueWithIdentifier:@"login" sender:self];
}

- (void)didReceiveValidToken {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([appDelegate.sessionManager isAuthentified] == YES) {
		//TODO: - get user informations
		//      - set AccountRecord
		[self performSelectorOnMainThread:@selector(loadActivityViewController) withObject:nil waitUntilDone:NO];
	}
	else {
		//TODO: delete cookie
		//GO on login view
		self.loginAcivityIndicator.hidden = YES;
		self.loginButton.hidden = NO;
		[self.loginAcivityIndicator stopAnimating];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feil innlogging" message:@"Brukernavn eller passord er feil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
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
