//
//  SettingsViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SettingsViewController.h"
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
	self.displayFollowedStickersEnabledSwitch.on = [[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled boolValue];
	self.locatePhoneEnabledSwitch.on = [[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
//	NSError *error;
	[[AppDelegate appDelegate] saveContext];
//	
//	if (![[AppDelegate appDelegate].managedObjectContext save:&error])
//		NSLog(@"Error saving !! -> %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (IBAction)handleDisplayFollowedStickersEnabled:(id)sender {
	
	[AppDelegate appDelegate].optionsRecord.displayFollowedStickersEnabled = [NSNumber numberWithBool:![self.optionsRecord.displayFollowedStickersEnabled boolValue]];
}

- (IBAction)handleLocatePhoneEnabled:(id)sender {
	//INFO: check if the user have enabled location on his phone
	[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled = [NSNumber numberWithBool:![[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue]];
	[[AppDelegate appDelegate] saveContext];
	
	if ([[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue]== YES) {
		[[AppDelegate appDelegate].locationManager start];
		//TODO: may be check if -> locationManager start -> OK
		[[AppDelegate appDelegate] addMyPhone];
	} else {
		[[AppDelegate appDelegate].locationManager stop];
		
	}
}

@end
