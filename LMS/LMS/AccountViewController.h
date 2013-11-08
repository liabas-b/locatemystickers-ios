//
//  AccountViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/28/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSTableViewController.h"

@interface AccountViewController : LMSTableViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@end
