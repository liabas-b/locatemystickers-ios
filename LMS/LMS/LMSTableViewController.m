//
//  LMSTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSTableViewController.h"
#import "AppDelegate.h"

@interface LMSTableViewController ()

@end

@implementation LMSTableViewController

#pragma mark - Init

- (id)init {
	self = [super init];
	if (self) {
		[self configure];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self configure];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self configure];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		[self configure];
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.view setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
	//INFO: iOS 6
	/*
	 UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	 [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]];
	 [self.tableView setBackgroundView:backgroundView];
	 */
	if (self.refreshControlEnabled == YES) {
		self.refreshControl = [[UIRefreshControl alloc] init];
		//INFO: setting up refreshControl
		[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
					  forControlEvents:UIControlEventValueChanged];
		
		//[self.refreshControl setTintColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.630 alpha:1.000]];
		[self.tableView addSubview:self.refreshControl];
		
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	[super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure

- (void)configure {
	self.appDelegate = [AppDelegate appDelegate];
}

#pragma mark - Base logic

- (void)configureView {
    DLog(@"");
}

- (void)setupData {
    DLog(@"");
}

- (void)registerNibs {
    DLog(@"");
}

- (void)setupView {
    DLog(@"");
}

#pragma mark - Refresh Control

- (void)refreshControlRequest {
	DLog(@"Refresh table view");
	[self.refreshControl endRefreshing];
}

@end
