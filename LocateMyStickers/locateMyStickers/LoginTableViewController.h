//
//  LoginTableViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LROAuth2ClientDelegate.h"
#import "SessionDelegate.h"

//@class LROAuth2Client;
@class PopUpLoginView;

@interface LoginTableViewController : UITableViewController <UITextFieldDelegate, SessionDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginAcivityIndicator;

@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet PopUpLoginView *popupLoginView;


- (IBAction)loginButton:(id)sender;

@end
