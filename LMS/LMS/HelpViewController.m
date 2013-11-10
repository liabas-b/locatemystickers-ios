//
//  HelpViewController.m
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "HelpViewController.h"
#import "UIViewController+Extension.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

#pragma mark - Configure

- (void)configure {
	[super configure];
	
	[self configureView];
	[self registerNibs];
	[self setupData];
	[self setupView];
}

#pragma mark - Base logic

- (void)configureView {
    [super configureView];
	
	self.title = @"Help";
	
	[self configureMenuLeftButtonWithBackButon:YES];
	self.view.backgroundColor = [UIColor backgroundColor];
	self.view = [self generateRadielGradiantBackgoundView];
}

- (void)registerNibs {
    [super registerNibs];
}

- (void)setupData {
	[super setupData];
}

- (void)setupView {
	[super setupView];
}

#pragma mark - Standar init


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
