//
//  LoginViewController.h
//  LMS
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BButton.h>
#import "LMSTableViewController.h"
#import "TopMenuView.h"

#import "LMSTextField.h"

@class PopUpLoginView;

@interface LoginViewController : LMSTableViewController <UITextFieldDelegate, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet TopMenuView *topLoginView;

@property (strong, nonatomic) IBOutlet BButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginAcivityIndicator;

@property (strong, nonatomic) IBOutlet LMSTextField *loginTextField;
@property (strong, nonatomic) IBOutlet LMSTextField *passwordTextField;

@property (strong, nonatomic) IBOutlet PopUpLoginView *popupLoginView;

- (IBAction)loginButton:(id)sender;

@end
