//
//  UserTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface UserTableViewController : BaseTableViewController

@property (strong, nonatomic) IBOutlet UILabel *yourStickersLabel;
@property (strong, nonatomic) IBOutlet UILabel *sharringStickersLabel;

@end
