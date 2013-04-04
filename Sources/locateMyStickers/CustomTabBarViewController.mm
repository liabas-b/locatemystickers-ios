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

#import "StickerAddingTableViewController.h"

#import <QRCodeReader.h>
#import "ScanWidgetController.h"

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
	
	self.scanWidgetController = (ScanWidgetController *)[storyboard instantiateViewControllerWithIdentifier:@"scanner"];
	//[[ScanWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
	[self.scanWidgetController setupWithDelegate:self showCancel:YES OneDMode:NO];
	QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader, nil];
	self.scanWidgetController.readers = readers;
	
	[self presentViewController:self.scanWidgetController animated:YES completion:nil];
	
	if ([self.delegate respondsToSelector:@selector(didTouchButton:)]) {
		[self.delegate didTouchButton:self];
	}
}

#pragma mark - ZXingWidgetController

- (void)zxingController:(ScanWidgetController *)controller didScanResult:(NSString *)result manualMode:(BOOL)manual {
	NSLog(@"result: %@", result);
	
	//INFO: dissmiss cureent view
	[self.scanWidgetController dismissViewControllerAnimated:YES completion:^ {
		[self performSelectorOnMainThread:@selector(handleStickerAdding:) withObject:result waitUntilDone:NO];
	}];
	
	//INFO: show Sticker adding view
	
}

- (void)handleStickerAdding:(NSString *)result {
	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	
	StickerAddingTableViewController *stickerAddingTableViewController  = (StickerAddingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"stickerAdding"];
	stickerAddingTableViewController.result = result;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:stickerAddingTableViewController];
	[self presentViewController:navigationController animated:YES completion:nil];
}

- (void)zxingControllerDidCancel:(ScanWidgetController *)controller {
	NSLog(@"cancel from zxing view");
	[self.scanWidgetController dismissViewControllerAnimated:YES completion:nil];
}



@end
