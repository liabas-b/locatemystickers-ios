//
//  ABLoginViewController.m
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LoginViewController.h"

#import "PopUpLoginView.h"

#import <FacebookSDK/FacebookSDK.h>

#import "Parameters.h"
#import "UITextField+Extended.h"

#import "AppDelegate.h"

static NSString* const keyHideKeyboard = @"hideKeyboard";
static NSString* const keyLoginResult = @"loginResult";

@interface LoginViewController () <FBLoginViewDelegate>

@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@end

@implementation LoginViewController

#pragma mark - Configure

- (void)configure {
	[super configure];
	
	[self configureView];
	[self registerNibs];
	[self setupData];
	[self setupView];
}

#pragma mark - Base logic

- (void)configureView {
	[super configureView];
	
	self.topLoginView.appNameLabel.text = self.appDelegate.appParameters.parameters.appName;
	
	self.loginTextField.nextTextField = self.passwordTextField;
	self.passwordTextField.nextTextField = nil;
		
//	UIImage *backgroundImage = [UIImage imageNamed:@"Background"];
//	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
	
	
//	[self.tableView setBackgroundView:backgroundView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.tableView.backgroundColor = [UIColor whiteColor];
	
	//INFO: Password TextField
	self.passwordTextField.borderStyle = UITextBorderStyleNone;
	
	self.passwordTextField.layer.masksToBounds = YES;
	self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
	self.passwordTextField.font = [UIFont defaultFont];
	
	[[self.passwordTextField layer] setBorderColor:[UIColor defaultSelectedFontColor].CGColor];
	
	//INFO: Login TextField
	self.loginTextField.borderStyle = UITextBorderStyleNone;
	
	self.loginTextField.layer.masksToBounds = YES;
	self.loginTextField.backgroundColor = [UIColor whiteColor];
    self.loginTextField.layer.borderWidth = 1.0f;
	self.loginTextField.font = [UIFont defaultFont];
	
	[[self.loginTextField layer] setBorderColor:[UIColor defaultSelectedFontColor].CGColor];
	
	//INFO: UITapGestureRecognizer
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:keyHideKeyboard object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:keyLoginResult object:nil];
	
	//
	
	/*
	FBLoginView *loginview = [[FBLoginView alloc] init];
	
	
	
	//
	
	loginview.frame = CGRectMake(10, 10, 30, 30);
	for (id obj in loginview.subviews)
	{
		if ([obj isKindOfClass:[UIButton class]])
		{
			UIButton * loginButton = obj;
			UIImage *loginImage = [UIImage imageNamed:@"lms-300.png"];
			[loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
			[loginButton setBackgroundImage:nil forState:UIControlStateSelected];
			[loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
			[loginButton sizeToFit];
		}
		if ([obj isKindOfClass:[UILabel class]])
		{
			UILabel * loginLabel =  obj;
//			loginLabel = nil;
			loginLabel.text = @"";//@"Log in to facebook";
//			loginLabel.textAlignment = UITextAlignmentCenter;
//			loginLabel.frame = CGRectMake(0, 0, 0, 0);
		}
	}

	//
	
	
//    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
	
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, 5, 25);
    }
#endif
#endif
#endif
	 
    loginview.delegate = self;
	
    [self.view addSubview:loginview];
	
	[loginview sizeToFit];
	 */
	
}

- (void)registerNibs {
	[super registerNibs];
}

- (void)setupData {
	[super setupData];
	
}

- (void)setupView {
	[super setupView];
}

#pragma mark - View controller life cycle

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
	
	UIColor *color = [UIColor colorFromHexString:self.appDelegate.appParameters.parameters.color];
	self.loginButton.color = color;
}

- (void)setupStyle {
	

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
		
//		[self setupSessionManager];
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

#pragma mark - UICollectionViewDelegate
/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	LMSMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCollection" forIndexPath:indexPath];
	LMSSticker *sticker = [self.stickerList objectAtIndex:indexPath.row];
	
	cell.titleLabel.text = [NSString stringWithFormat:@"%@", sticker.name];
	cell.defaultColor = [UIColor wheatColor];
	cell.selectedColor = [UIColor colorFromHexString:sticker.color];
	
	return cell;
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%s | indexPath.row: %d", __PRETTY_FUNCTION__, indexPath.row);
	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	/*
	LMSSticker *sticker = [self.stickerList objectAtIndex:indexPath.row];
	
	[self loadSticker:sticker];
*/
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
	
	//StickerRecord *stickerRecord = [self.stickerRecordList objectAtIndex:indexPath.row];
	
	//[self loadSticker:stickerRecord];
}


#pragma mark - Handlers

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


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
//    self.buttonPostPhoto.enabled = YES;
//    self.buttonPostStatus.enabled = YES;
//    self.buttonPickFriends.enabled = YES;
//    self.buttonPickPlace.enabled = YES;
	
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
//    [self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
	DLog(@"loginView: %@", loginView);
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
//    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
//    self.profilePic.profileID = user.id;
    self.loggedInUser = user;
	DLog(@"loggedInUser: %@", self.loggedInUser);
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
	
//    self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
//    self.buttonPostPhoto.enabled = NO;
//    self.buttonPickFriends.enabled = NO;
//    self.buttonPickPlace.enabled = NO;
	
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
//    [self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
	
//    self.profilePic.profileID = nil;
//    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
	
}

// Post Status Update button handler; will attempt different approaches depending upon configuration.
- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
	
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
	
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
	
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:@"Hello Facebook"
                                                       caption:nil
                                                   description:@"The 'Hello Facebook' sample application showcases simple Facebook integration."
                                                       picture:nil
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               NSLog(@"Success!");
                                                           }
                                                       }];
	
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:nil
                                                                                    image:nil
                                                                                      url:urlToShare
                                                                                  handler:nil];
		
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", self.loggedInUser.first_name, [NSDate date]];
				
                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
				
                connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
				| FBRequestConnectionErrorBehaviorAlertUser
				| FBRequestConnectionErrorBehaviorRetry;
				
                [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
						 
						 [self showAlert:message result:result error:error];
//						 self.buttonPostStatus.enabled = YES;
					 }];
                [connection start];
				
//                self.buttonPostStatus.enabled = NO;
            }];
        }
    }
}

// Post Photo button handler
- (IBAction)postPhotoClick:(UIButton *)sender {
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    UIImage *img = [UIImage imageNamed:@"Icon-72@2x.png"];
	
    [self performPublishAction:^{
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
		| FBRequestConnectionErrorBehaviorAlertUser
		| FBRequestConnectionErrorBehaviorRetry;
		
        [connection addRequest:[FBRequest requestForUploadPhoto:img]
             completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
				 
                 [self showAlert:@"Photo Post" result:result error:error];
                 if (FBSession.activeSession.isOpen) {
//                     self.buttonPostPhoto.enabled = YES;
                 }
			 }];
        [connection start];
		
//        self.buttonPostPhoto.enabled = NO;
    }];
}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
	
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {
		 
         if (!donePressed) {
             return;
         }
		 
         NSString *message;
		 
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
			 
             NSMutableString *text = [[NSMutableString alloc] init];
			 
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
		 
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// Pick Place button handler
- (IBAction)pickPlaceClick:(UIButton *)sender {
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.title = @"Pick a Seattle Place";
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(47.6097, -122.3331);
    [placePickerController loadData];
	
    // Use the modal wrapper method to display the picker.
    [placePickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {
		 
         if (!donePressed) {
             return;
         }
		 
         NSString *placeName = placePickerController.selection.name;
         if (!placeName) {
             placeName = @"<No Place Selected>";
         }
		 
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:placeName
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
	
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
			
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
	
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}




@end
