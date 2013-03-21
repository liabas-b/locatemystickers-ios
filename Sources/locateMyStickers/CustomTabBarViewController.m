//
//  CustomTabBarViewController.m
//  locatemystickers
//
//  Created by Adrien Guffens on 10/29/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "StickerAddingTableViewController.h"
#import "AppDelegate.h"
#import "ImageTools.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (id)initWithButtonImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName {
	self.buttonImage = [UIImage imageNamed:imageName];
	self.highlightImage = [UIImage imageNamed:highlightImageName];

	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.buttonImage = [UIImage imageNamed:@"locateMyStickersRedLogo"];
	self.highlightImage = [UIImage imageNamed:@"locateMyStickersWhiteLogo"];

	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
	
	button.frame = CGRectMake(0.0, 0.0, 38, 36);
	//ButtonImage.size.width, ButtonImage.size.height);
	//	button.frame = CGRectMake(0.0, 0.0, 60, 80);//ButtonImage.size.width, ButtonImage.size.height);
	//	button.frame = CGRectMake(0.0, 0.0, 60, 60);//ButtonImage.size.width, ButtonImage.size.height);

	[button setBackgroundImage:self.buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:self.highlightImage forState:UIControlStateHighlighted];
	
	CGFloat heightDifference = button.frame.size.height - self.tabBar.frame.size.height;
	if (heightDifference < 0) {
		CGPoint center = self.tabBar.center;
		center.y = center.y - 0.0;
		button.center = center;
	}
	
	else {
		CGPoint center = self.tabBar.center;
		center.y = (center.y - heightDifference / 2.0) - 0.0;
		button.center = center;
	}
	
	//[ImageTools addBorderToLayer:button.layer withBorderRaduis:4.0];
	
	[self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomTabBarProtocol

- (void)didTouchButton:(id)sender {
	
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	StickerAddingTableViewController *stickerAddingTableViewController  = (StickerAddingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"stickerAdding"];
	
	[self presentViewController:stickerAddingTableViewController animated:YES completion:nil];
	//	[self pushViewController:stickerAddingTableViewController animated:YES];
	
	if ([self.delegate respondsToSelector:@selector(didTouchButton:)]) {
		[self.delegate didTouchButton:self];
	}
}

@end
