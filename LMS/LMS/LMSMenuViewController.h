//
//  LMSMenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "LMSViewController.h"

@class LMSTableView;
@class LMSLabel;
@class TopMenuView;

@interface LMSMenuViewController : LMSViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet LMSTableView *tableView;

@end
