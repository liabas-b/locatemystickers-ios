//
//  LMSTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface LMSTableViewController : UITableViewController

@property (nonatomic, assign) BOOL refreshControlEnabled;

- (void)refreshControlRequest;

//INFO: Main logic
- (void)configureView;
- (void)setupData;

- (void)registerNibs;
- (void)setupView;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end
