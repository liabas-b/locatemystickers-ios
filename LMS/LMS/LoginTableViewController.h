//
//  ABLoginTableViewController.h
//  AB
//
//  Created by Adrien Guffens on 1/10/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BButton.h>
#import "LMSTableViewController.h"

@class PopUpLoginView;

@interface LoginTableViewController : LMSTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet BButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginAcivityIndicator;

@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet PopUpLoginView *popupLoginView;

- (IBAction)loginButton:(id)sender;

@end
