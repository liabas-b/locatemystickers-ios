//
//  AccountViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/28/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end
