//
//  SettingsViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SettingsViewController.h"

#import "StickerRecord+Manager.h"
#import "StickerRecord.h"

#import "StickerAddingTableViewController.h"

#import "JsonTools.h"
#import "NSDictionary+QueryString.h"

#import "AppDelegate.h"
#import "LocationManager.h"

#import "UIViewController+Extension.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureMenuLeftButtonWithBackButon:[self.navigationController.viewControllers count] > 1];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//INFO: subscribe to StickerAlreadyExistOnWebService
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerStickerAlreadyExistOnWebService:) name:keyStickerAlreadyExistOnWebService object:nil];
	
	[self bindView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:keyStickerAlreadyExistOnWebService object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Binding

- (void)bindView {
	NSLog(@"%s %d", __PRETTY_FUNCTION__, [[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue]);
	self.displayFollowedStickersEnabledSwitch.on = [[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled boolValue];
	self.locatePhoneEnabledSwitch.on = [[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)addMyPhone {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	//INFO: start location tracking
	if (self.locatePhoneEnabledSwitch.on == YES) {
		NSString *identifier = [AppDelegate identifierForCurrentUser];
		NSLog(@"%s | identifier: %@", __PRETTY_FUNCTION__, identifier);
		bool stickerAlreadyExist = [[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnPhoneWithCode:identifier];
		
		//INFO: sucess
		if (stickerAlreadyExist == NO) {
			NSLog(@"%s | sticker does not exist in local record", __PRETTY_FUNCTION__);
			[[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnWebServiceWithCode:identifier];
		}
		else {
			NSLog(@"%s | sticker already exist in local record", __PRETTY_FUNCTION__);
			[[AppDelegate appDelegate].locationManager startWithStickerCode:identifier];
			
			[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		}
	}
	//INFO: stop location tracking
	else  {
		[[AppDelegate appDelegate].locationManager stop];
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
	}
}

#pragma mark - Handler

- (void)handlerStickerAlreadyExistOnWebService:(NSNotification *)notificaton {
	NSLog(@"%s | %d", __PRETTY_FUNCTION__, [[notificaton object] boolValue]);
	if ([[notificaton object] boolValue] == NO) {//INFO: Sticker not Already Exist On Web Service
		NSLog(@"%s | sticker not already exist on web service", __PRETTY_FUNCTION__);
		NSString *identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//INFO: >= iOS 6
																									//TODO: check if the phone is alredy added
		
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithCode:identifierForVendor];
		stickerRecord.name = @"My phone ;)";
		stickerRecord.text = @"My phone was adding today";
		stickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeIphone];
		stickerRecord.code = [AppDelegate identifierForCurrentUser];
		
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
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
		
		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
			OptionsRecord *localOptionsRecord = [[AppDelegate appDelegate].optionsRecord inContext:localContext];
			localOptionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		}completion:^{
			NSLog(@"%s saved OptionsRecord", __PRETTY_FUNCTION__);
		}];
		
	}
}

- (IBAction)handleDisplayFollowedStickersEnabled:(id)sender {
	
	[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:![self.optionsRecord.displayFollowedStickersEnabled boolValue]];
}

- (IBAction)handleLocatePhoneEnabled:(id)sender {
	[self addMyPhone];
}


@end
