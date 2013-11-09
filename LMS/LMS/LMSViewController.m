//
//  LMSViewController.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSViewController.h"
#import "AppDelegate.h"
#import <REFrostedViewController.h>


@implementation LMSViewController

#pragma mark - Init

- (id)init {
	self = [super init];
	if (self) {
//		[self configure];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
//		[self configure];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//		[self configure];
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad {
	self.navigationController.navigationBar.translucent = NO;
    [super viewDidLoad];

	[self configure];
//	[self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:NO];

	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //INFO: do more stuff if needed
}

#pragma mark - Configure

- (void)configure {
	self.screenName = [[self class] description];
	self.appDelegate = [AppDelegate appDelegate];
}

#pragma mark - Base logic

- (void)configureView {
    DLog(@"");
}

- (void)registerNibs {
    DLog(@"");
}

- (void)setupData {
    DLog(@"");
}

- (void)setupView {
    DLog(@"");
}
//
//#pragma mark - Navigation Bar handler
//
//- (void)leftMenuButtonPress:(id)sender {
//	[self.frostedViewController hideMenuViewController];
//}
//
//- (void)backButtonPress:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
