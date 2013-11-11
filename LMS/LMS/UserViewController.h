//
//  UserViewController.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSViewController.h"
#import "LMSTableView.h"

@interface UserViewController : LMSViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet LMSTableView *tableView;

@end
