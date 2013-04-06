//
//  SearchTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property(nonatomic, strong)NSMutableArray *searchRecordList;
@property(strong,nonatomic)NSMutableArray *filteredSearchRecordList;
@property(strong, nonatomic)UITableView *searchTableView;

@end
