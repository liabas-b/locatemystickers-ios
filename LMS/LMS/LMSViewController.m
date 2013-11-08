//
//  LMSViewController.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSViewController.h"


@implementation LMSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenName = nibNameOrNil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.screenName = [[self class] description];
	}
	return self;
}


- (id)init {
	self = [super init];
	if (self) {
		self.screenName = [[self class] description];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//INFO: Do any additional setup after loading the view.
    
	self.navigationController.navigationBar.translucent = NO;

	//INFO: End
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //INFO: do more stuff if needed
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

@end
