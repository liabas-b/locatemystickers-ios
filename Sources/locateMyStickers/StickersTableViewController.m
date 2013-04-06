//
//  StickersTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickersTableViewController.h"
#import "StickerCell.h"
#import "AppDelegate.h"

#import "MapViewController.h"
#import "StickerDetailViewController.h"

#import "OptionsRecord.h"
#import "OptionsRecord+Manager.h"

#import "StickerRecord.h"
#import "BButton.h"

#import "JsonTools.h"

#import "UCTabBarItem.h"

#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

#import "StickerRecord+Manager.h"


@interface StickersTableViewController ()

@end

@implementation StickersTableViewController

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
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	
	self.myPhoneStickerRecordList = nil;
	self.stickersRecordList = nil;
	
	//INFO: setting up refreshControl
	[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
				  forControlEvents:UIControlEventValueChanged];
	
	//[RefreshControl setTintColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.630 alpha:1.000]];
	[self.tableView addSubview:self.refreshControl];
	
	[self setup];
	
	[self parseData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self fetchStickersList];
	//[self.tableView reloadData];
}

- (void)setup {
	
	//INFO: setup location manager
	//INFO: options
/*
	self.optionsRecord = [[OptionsRecord optionsRecordsInManagedObjectContext:[AppDelegate appDelegate].managedObjectContext] lastObject];//[fetchedObjects lastObject];

	if ([self.optionsRecord.locatePhoneEnabled boolValue] == YES) {
		[[AppDelegate appDelegate].locationManager start];
	}
	*/
	[self fetchStickersList];
}

- (void)fetchStickersList {
	
	///self.optionsRecord = [[OptionsRecord optionsRecordsInManagedObjectContext:[AppDelegate appDelegate].managedObjectContext] lastObject];//[fetchedObjects lastObject];
	
	if ([[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue] == YES) {
		[[AppDelegate appDelegate].locationManager start];
	}
	//
	if ([[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue] == YES) {
		
	}
	
	NSArray *fetchedPhoneStickersRecordObjects = [StickerRecord stickerRecordsOfStickerTypeId:2 managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	self.myPhoneStickerRecordList = [[NSMutableArray alloc] initWithArray:fetchedPhoneStickersRecordObjects];

	//INFO: Stickers
	NSArray *fetchedStickersRecordObjects = [StickerRecord stickerRecordsOfStickerTypeId:1 managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	self.stickersRecordList = [[NSMutableArray alloc] initWithArray:fetchedStickersRecordObjects];
	
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"Stickers"
											imageSelected:@"home_black"
											andUnselected:@"home_white"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([self.myPhoneStickerRecordList count] > 0)
		return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) //&& [[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue] == YES)
		return [self.myPhoneStickerRecordList count];
	return [self.stickersRecordList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StickerCell";
    StickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if ([cell isKindOfClass:[StickerCell class]]) {
		NSLog(@"StickersTableViewController: Configure Cell");
		[self configureCell:cell atIndexPath:indexPath];
	}
    // Configure the cell...
    
    return cell;
}

+ (NSDate *)getDate:(NSString *)date withFormat:(NSString *)format {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	return ([dateFormat dateFromString:date]);
}


+ (NSString *)getDiffTimeInStringFromDate:(NSDate *)date { //(NSString *)stringDate withFormat:(NSString *)format {
	NSString *dateFromPublishedDate;
	
	NSDate *baseDate = [StickersTableViewController getDate:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *currDate = [NSDate date];
	NSTimeInterval diff = [currDate timeIntervalSinceDate:baseDate];
	
	NSInteger secondsDiff = diff;
	NSInteger minutesDiff = diff / 60;
	NSInteger houresDiff = (diff / 60) / 60;
	NSInteger daysDiff = (((diff / 60) / 60) / 24);
	NSInteger monthsDiff = ((((diff / 60) / 60) / 24 / 31));
	NSInteger yearsDiff = ((((diff / 60) / 60) / 24 / 31 / 12));
	
	if (secondsDiff < 60)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d sec", secondsDiff];
	else if (minutesDiff < 60)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d min", minutesDiff];
	else if (houresDiff < 24)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d hour", houresDiff];
	else if (daysDiff < 31)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d day", daysDiff];
	else if (monthsDiff < 12)
		dateFromPublishedDate = [NSString stringWithFormat:@"%d month", monthsDiff];
	else
		dateFromPublishedDate = [NSString stringWithFormat:@"%d years", yearsDiff];
	
	return dateFromPublishedDate;
}


- (void)configureCell:(StickerCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	static NSDateFormatter *formatter = nil;
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
	}
	//TODO: configure cell with the sticker model
	
	//if ([self.stickersRecordList count] > 0) {
	StickerRecord *stickerRecord = nil;
	if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] > 0)
		stickerRecord = [self.myPhoneStickerRecordList objectAtIndex:indexPath.row];
	else if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] == 0)
		stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
	else if (indexPath.section == 1)
		stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
	
	[stickerRecord debug];
	
	cell.nameLabel.text = stickerRecord.name;
	cell.mapButton.tag = indexPath.row;
	/*
	 NSString *timeString = [StickersTableViewController getDiffTimeInStringFromDate:stickerRecord.createdAt];
	 cell.timeLabel.text = timeString;//stickerRecord.createdAt;
	 */
	if (stickerRecord.isActive)
		cell.activatedImage.backgroundColor = [UIColor greenColor];
	else
		cell.activatedImage.backgroundColor = [UIColor redColor];
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];

	backgroundView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
	//backgroundView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
	
	cell.backgroundView = backgroundView;
	
	cell.iconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
	if ([stickerRecord.stickerTypeId intValue] > 1) {
		cell.iconLabel.text = [NSString stringWithFormat:@" %@", [NSString fontAwesomeIconStringForEnum:FAIconMobilePhone]];
	}
	else
		cell.iconLabel.text = [NSString fontAwesomeIconStringForEnum:FAIconQrcode];
	
	
	
	/*
	 ScoreRecord *scoreRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
	 
	 ScoreRecordCell *custumCell = (ScoreRecordCell *)cell;
	 
	 custumCell.titleLabel.text = [NSString stringWithFormat:@"%@%% completed with size %@", scoreRecord.score, scoreRecord.size];
	 //custumCell.timeLabel.text = [NSString stringWithFormat:@"%@ s", scoreRecord.duration];
	 
	 int forHours = [scoreRecord.duration intValue] / 3600;
	 int remainder = [scoreRecord.duration intValue] % 3600;
	 int forMinutes = remainder / 60;
	 int forSeconds = remainder % 60;
	 
	 if (forHours > 0)
	 custumCell.timeLabel.text = [NSString stringWithFormat:@"%d hours %d seconds %d ", forHours, forMinutes, forSeconds];
	 else if (forMinutes > 0)
	 custumCell.timeLabel.text = [NSString stringWithFormat:@"%d minutes %d seconds", forMinutes, forSeconds];
	 else
	 custumCell.timeLabel.text = [NSString stringWithFormat:@"%d seconds", forSeconds];
	 
	 //INFO: set background and icon
	 UIView *backgroundView = [[UIView alloc] init];
	 
	 if ([scoreRecord.score intValue] >= 100) {
	 backgroundView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
	 custumCell.iconImageView.image = winImage;
	 }
	 else {
	 backgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
	 custumCell.iconImageView.image = looseImage;
	 }
	 
	 [cell setBackgroundView:backgroundView];
	 */
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

//mapDetail

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mapDetail"]) {
		int row = ((BButton*)sender).tag;
#warning --> TO test
		NSLog(@"mapDetail id: %d", row);
		StickerRecord *stickerRecord = [self.stickersRecordList objectAtIndex:row];
		MapViewController *mapViewController = [segue destinationViewController];
		
		mapViewController.stickerRecord = stickerRecord;
	}//stickerDetail
	if ([[segue identifier] isEqualToString:@"stickerDetail"]) {
		StickerDetailViewController *stickerDetailViewController = [segue destinationViewController];
		StickerRecord *stickerRecord = nil;
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] > 0)
			stickerRecord = [self.myPhoneStickerRecordList objectAtIndex:indexPath.row];
		else if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] == 0)
			stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
		else if (indexPath.section == 1)
			stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
		
		stickerDetailViewController.stickerRecord = stickerRecord;
	}
}

#pragma mark - data parsing

- (void)parseData
{
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	NSString *requestString = [NSString stringWithFormat:@"%@/users/3/stickers.json", hostName];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveData:data];
	}];
}

- (void)didReceiveData:(NSData *)data {
	//INFO: debug
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		//NSLog(@"%@", [dataDictionary objectForKey:@"data"]);
		
		for (NSDictionary *item in [dataDictionary objectForKey:@"data"]) {
			StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:item managedObjectContext:[AppDelegate appDelegate].managedObjectContext];
		}
		[[AppDelegate appDelegate] saveContext];
		//TODO: check if we have to fetch for the new/update entry
		[self fetchStickersList];
//		[self.tableView reloadData];
		
	}
	[self.refreshControl endRefreshing];
}

#pragma mark - Refresh Control

- (void)refreshControlRequest
{
	NSLog(@"refreshing...");
		
	// Update the table
	[self parseData];
	
	//[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(endRefreshControl:) userInfo:nil repeats:NO];
}

- (void)endRefreshControl:(NSTimer *)timer {
	[self.refreshControl endRefreshing];
}


@end
