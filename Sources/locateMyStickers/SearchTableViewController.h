//
//  SearchTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerCell.h"
#import "UserCell.h"

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, MCSwipeStickerTableViewCellDelegate, MCSwipeUserTableViewCellDelegate>

@property(nonatomic, strong)NSMutableArray *searchRecordList;
@property(strong,nonatomic)NSMutableArray *filteredSearchRecordList;
@property(strong, nonatomic)UITableView *searchTableView;

@end
