//
//  SettingsViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SettingsViewController.h"

#import "LMSSticker+Manager.h"
#import "LMSSticker.h"

#import "StickerAddingTableViewController.h"

//#import "JsonTools.h"
#import "NSDictionary+QueryString.h"

#import "AppDelegate.h"
//#import "LocationManager.h"

#import "UIViewController+Extension.h"

#import <FacebookSDK/FacebookSDK.h>

@interface SettingsViewController () <FBLoginViewDelegate>

@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureMenuLeftButtonWithBackButon:[self.navigationController.viewControllers count] > 1];
	
	[self addFBLogin];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//INFO: subscribe to StickerAlreadyExistOnWebService
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerStickerAlreadyExistOnWebService:) name:keyStickerAlreadyExistOnWebService object:nil];
	
	[self bindView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyStickerAlreadyExistOnWebService object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Binding

- (void)bindView {
//	NSLog(@"%s %d", __PRETTY_FUNCTION__, [[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue]);
//	self.displayFollowedStickersEnabledSwitch.on = [[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled boolValue];
//	self.locatePhoneEnabledSwitch.on = [[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)addMyPhone {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	//INFO: start location tracking
	/*
	if (self.locatePhoneEnabledSwitch.on == YES) {
		NSString *identifier = [AppDelegate identifierForCurrentUser];
		NSLog(@"%s | identifier: %@", __PRETTY_FUNCTION__, identifier);
		bool stickerAlreadyExist = [[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnPhoneWithCode:identifier];
		
		//INFO: sucess
		if (stickerAlreadyExist == NO) {
			NSLog(@"%s | sticker does not exist in local record", __PRETTY_FUNCTION__);
			[[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnWebServiceWithCode:identifier];
		}
		else {
			NSLog(@"%s | sticker already exist in local record", __PRETTY_FUNCTION__);
			[[AppDelegate appDelegate].locationManager startWithStickerCode:identifier];
			
			[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		}
	}
	//INFO: stop location tracking
	else  {
		[[AppDelegate appDelegate].locationManager stop];
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
	}
	 */
}

#pragma mark - Handler

- (void)handlerStickerAlreadyExistOnWebService:(NSNotification *)notificaton {
	/*
	NSLog(@"%s | %d", __PRETTY_FUNCTION__, [[notificaton object] boolValue]);
	if ([[notificaton object] boolValue] == NO) {//INFO: Sticker not Already Exist On Web Service
		NSLog(@"%s | sticker not already exist on web service", __PRETTY_FUNCTION__);
		NSString *identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//INFO: >= iOS 6
																									//TODO: check if the phone is alredy added
		
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithCode:identifierForVendor];
		stickerRecord.name = @"My phone ;)";
		stickerRecord.text = @"My phone was adding today";
		stickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeIphone];
		stickerRecord.code = [AppDelegate identifierForCurrentUser];
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		[[AppDelegate appDelegate] performSelectorOnMainThread:@selector(stickerAdding:) withObject:stickerRecord waitUntilDone:NO];
	}
	else {
		NSLog(@"%s Sticker already exist on web service", __PRETTY_FUNCTION__);
		
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
														 message:@"Sticker already exist on LocateMyStickers !"
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
        [alert show];
		
		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
			OptionsRecord *localOptionsRecord = [[AppDelegate appDelegate].optionsRecord inContext:localContext];
			localOptionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		}completion:^{
			NSLog(@"%s saved OptionsRecord", __PRETTY_FUNCTION__);
		}];
		
	}
	 */
}

- (IBAction)handleDisplayFollowedStickersEnabled:(id)sender {
	
//	[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:![self.optionsRecord.displayFollowedStickersEnabled boolValue]];
}

- (IBAction)handleLocatePhoneEnabled:(id)sender {
	[self addMyPhone];
}


//





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


//



- (void)addFBLogin {
	
	FBLoginView *loginview = [[FBLoginView alloc] init];
	
	
	
	//
	
	loginview.frame = CGRectMake(5, 0, 30, 30);
	/*
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
	 */
	
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
	
//    [self.view addSubview:loginview];
	[self.fbLoginView addSubview:loginview];
	
	[loginview sizeToFit];
	
}

@end
