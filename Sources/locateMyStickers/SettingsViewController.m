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
//#import "NSURL+QueryInspector.h"
#import "NSDictionary+QueryString.h"

#import "AppDelegate.h"
#import "LocationManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	/*
	 NSError *error;
	 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	 NSEntityDescription *entity = [NSEntityDescription entityForName:@"OptionsRecord"
	 inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	 [fetchRequest setEntity:entity];
	 [fetchRequest setReturnsObjectsAsFaults:NO];
	 NSArray *fetchedObjects = [[AppDelegate appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
	 self.optionsRecord = [fetchedObjects lastObject];
	 */
	[self setup];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//INFO: subscribe to StickerAlreadyExistOnWebService
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerStickerAlreadyExistOnWebService:) name:keyStickerAlreadyExistOnWebService object:nil];
	
	[self bindView];
	//	NSError *error;
	//[[AppDelegate appDelegate] saveContext];
	//
	//	if (![[AppDelegate appDelegate].managedObjectContext save:&error])
	//		NSLog(@"Error saving !! -> %@", error);
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:keyStickerAlreadyExistOnWebService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
		
	//INFO: configure view
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
}

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

- (IBAction)handleDisplayFollowedStickersEnabled:(id)sender {
	
	[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:![self.optionsRecord.displayFollowedStickersEnabled boolValue]];
}

- (IBAction)handleLocatePhoneEnabled:(id)sender {
	[self addMyPhone];
}

- (void)addMyPhone {
	NSLog(@"%s addMyPhone !!!", __PRETTY_FUNCTION__);
		
	if (self.locatePhoneEnabledSwitch.on == YES) {//INFO: start location tracking
		NSString *identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
		bool stickerAlreadyExist = [[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnPhoneWithCode:identifierForVendor];
		NSLog(@"%s ret %d !!!", __PRETTY_FUNCTION__, stickerAlreadyExist);
		
		//INFO: sucess
		if (stickerAlreadyExist == NO) {
			[[AppDelegate appDelegate].stickerManager stickerAlreadyExistOnWebServiceWithCode:identifierForVendor];
			
		}
		else {
			NSLog(@"%s sticker already exist !!!", __PRETTY_FUNCTION__);
			[[AppDelegate appDelegate].locationManager startWithStickerTrackingId:identifierForVendor];

			[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			 [[NSManagedObjectContext defaultContext] saveNestedContexts];
/*
			[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
				OptionsRecord *localOptionsRecord = [[AppDelegate appDelegate].optionsRecord inContext:localContext];
				localOptionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			}completion:^{
				NSLog(@"%s saved OptionsRecord", __PRETTY_FUNCTION__);
			}];
*/
#warning TODO SAVE CONTEXT
		}
	}
	else  {//INFO: stop location tracking
		[[AppDelegate appDelegate].locationManager stop];
		[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		/*
		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
			OptionsRecord *localOptionsRecord = [[AppDelegate appDelegate].optionsRecord inContext:localContext];
			localOptionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		}completion:^{
			NSLog(@"%s saved OptionsRecord", __PRETTY_FUNCTION__);
		}];
		 */
	}
}
/*
- (void)didReceiveData:(NSData *)data {
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		NSLog(@"%@", dataDictionary);
		if (dataDictionary != nil) {
			StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dataDictionary managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
			[stickerRecord debug];
			self.optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:YES];
			[[AppDelegate appDelegate] saveContext];
		}
	}
	
}
*/
- (void)handlerStickerAlreadyExistOnWebService:(NSNotification *)notificaton {
	NSLog(@"%s %d", __PRETTY_FUNCTION__, [[notificaton object] boolValue]);
	if ([[notificaton object] boolValue] == NO) {//INFO: Sticker not Already Exist On Web Service
		NSLog(@"%s Sticker not already exist on web service", __PRETTY_FUNCTION__);
		NSString *identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//INFO: >= iOS 6
																									//TODO: check if the phone is alredy added
		
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithCode:identifierForVendor];
#warning MAY be background is bad
		stickerRecord.name = @"My phone ;)";
		stickerRecord.text = @"My phone was adding today";
		stickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeIphone];
		stickerRecord.code = identifierForVendor;
		
		 [[NSManagedObjectContext defaultContext] saveNestedContexts];

		/*
		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
			StickerRecord *localStickerRecord = [stickerRecord inContext:localContext];
			localStickerRecord.name = @"My phone ;)";
			localStickerRecord.text = @"My phone was adding today";
			localStickerRecord.stickerTypeId = [NSNumber numberWithInt:StickerTypeIphone];
			localStickerRecord.code = identifierForVendor;			
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

		[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
			OptionsRecord *localOptionsRecord = [[AppDelegate appDelegate].optionsRecord inContext:localContext];
			localOptionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:NO];
		}completion:^{
			NSLog(@"%s saved OptionsRecord", __PRETTY_FUNCTION__);
		}];

	}
}


@end
