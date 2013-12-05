//
//  SearchViewController.h
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSViewController.h"
#import "LMSTableView.h"

@interface SearchViewController : LMSViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet LMSTableView *tableView;

@end
