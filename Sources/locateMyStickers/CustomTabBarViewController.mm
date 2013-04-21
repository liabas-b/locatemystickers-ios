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

#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

#import "StickerManager.h"

#import <QRCodeReader.h>
#import "ScanWidgetController.h"

@interface CustomTabBarViewController ()

@property (nonatomic, strong)NSString *currentCode;

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

//	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

	
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
	//TODO: check if the code is valid
	//
	//
	
	[self addStickerWithCode:result];
	
	
	
	//
	/*	UIStoryboard *storyboard = [AppDelegate mainStoryBoard];
	 
	 StickerAddingTableViewController *stickerAddingTableViewController  = (StickerAddingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"stickerAdding"];
	 stickerAddingTableViewController.result = result;
	 
	 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:stickerAddingTableViewController];
	 [self presentViewController:navigationController animated:YES completion:nil];
	 */
}

- (void)addStickerWithCode:(NSString *)code {
	bool stickerAlreadyExist = [[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnPhoneWithCode:code];
	NSLog(@"%s ret %d !!!", __PRETTY_FUNCTION__, stickerAlreadyExist);
	
	//TODO: waiting for the answer of the web service
	
	//INFO: sucess
	if (stickerAlreadyExist == NO) {//&& get notif from WS
		self.currentCode = code;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerStickerAlreadyExistOnWebService:) name:keyStickerAlreadyExistOnWebService object:nil];
		[[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnWebServiceWithCode:code];
	}
	else {
		UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
														 message:@"Sticker already exist !"
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
        [alert show];		
	}
	/*
	 {
	 StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithCode:result managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	 stickerRecord.name = @"New sticker ;)";
	 stickerRecord.text = @"New Sticker from space =)";
	 stickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeSticker];
	 stickerRecord.code = result;
	 [[AppDelegate appDelegate] performSelectorOnMainThread:@selector(stickerAdding:) withObject:stickerRecord waitUntilDone:NO];
	 
	 }
	 */
}

- (void)zxingControllerDidCancel:(ScanWidgetController *)controller {
	NSLog(@"cancel from zxing view");
	[self.scanWidgetController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlerStickerAlreadyExistOnWebService:(NSNotification *)notificaton {
	NSLog(@"%s %d", __PRETTY_FUNCTION__, [[notificaton object] boolValue]);
	if ([[notificaton object] boolValue] == NO) {//INFO: Sticker not Already Exist On Web Service
		NSLog(@"%s Sticker not already exist on web service", __PRETTY_FUNCTION__);
		
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithCode:self.currentCode];
#warning MAY be background is bad
		
	
		stickerRecord.name = @"New sticker ;)";
		stickerRecord.text = @"New Sticker from space =)";
		stickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeSticker];
		stickerRecord.code = self.currentCode;
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		/*
		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
			StickerRecord *localStickerRecord = [stickerRecord inContext:localContext];
			localStickerRecord.name = @"New sticker ;)";
			localStickerRecord.text = @"New Sticker from space =)";
			localStickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeSticker];
			localStickerRecord.code = self.currentCode;
		}completion:^{
			NSLog(@"%s saved StickerRecord", __PRETTY_FUNCTION__);
		}];
		*/
		
		[[AppDelegate appDelegate] performSelectorOnMainThread:@selector(stickerAdding:) withObject:stickerRecord waitUntilDone:NO];
		
	}
	else {
		NSLog(@"%s Sticker already exist on web service", __PRETTY_FUNCTION__);
		UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
														 message:@"Sticker already exist on LocateMyStickers !"
														delegate:nil
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
        [alert show];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyStickerAlreadyExistOnWebService object:nil];
}

@end
