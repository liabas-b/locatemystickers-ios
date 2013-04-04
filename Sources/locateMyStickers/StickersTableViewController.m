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

#import "OptionsRecord.h"

#import "StickerRecord.h"
#import "BButton.h"

#import "JsonTools.h"

#import "UCTabBarItem.h"

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
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	
	//INFO: setting up refreshControl
	[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
				  forControlEvents:UIControlEventValueChanged];
	
	//[RefreshControl setTintColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.630 alpha:1.000]];
	[self.tableView addSubview:self.refreshControl];
	
	[self setup];
	
	[self parseData];
}

- (void)setup {
	
	//INFO: setup location manager
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"OptionsRecord"
											  inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	NSArray *fetchedObjects = [[AppDelegate appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
	self.optionsRecord = [fetchedObjects lastObject];
	
	if ([self.optionsRecord.locatePhoneEnabled boolValue]== YES) {
		[[AppDelegate appDelegate].locationManager start];
	}
	
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
	
	if ([self.stickersRecordList count] > 0) {
		StickerRecord *stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
		
		[stickerRecord debug];
		
		cell.nameLabel.text = stickerRecord.name;
		cell.mapButton.tag = indexPath.row;
		
		NSString *timeString = [StickersTableViewController getDiffTimeInStringFromDate:stickerRecord.createdAt];
		cell.timeLabel.text = timeString;//stickerRecord.createdAt;
		if (stickerRecord.isActive)
			cell.activatedImage.backgroundColor = [UIColor greenColor];
		else
			cell.activatedImage.backgroundColor = [UIColor redColor];
	}
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//mapDetail

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mapDetail"]) {
		int row = ((BButton*)sender).tag;
#pragma warning --> TO test
		NSLog(@"mapDetail id: %d", row);
		StickerRecord *stickerRecord = [self.stickersRecordList objectAtIndex:row];
		MapViewController *mapViewController = [segue destinationViewController];
		
		mapViewController.stickerRecord = stickerRecord;
	}
}


#pragma mark - data parsing

- (void)parseData
{
	
    // TODO: Create an Operation Queue [OK]
	
	
	//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://web-service.locatemystickers.com/users/1/stickers.json"]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.100:3000/users/1/stickers.json"]];
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveData:data];
	}];
}

- (void)didReceiveData:(NSData *)data {
	//INFO: debug
	/*
	 if (data) {
	 NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	 NSLog(@"------ <%@>", dataString);
	 }
	 else
	 NSLog(@"BAD");
	 */
	
	if (data) {
		//TODO: save file
		if (self.stickersRecordList) {
			[self.stickersRecordList removeAllObjects];
		}
		
		self.stickersRecordList = [[NSMutableArray alloc] init];
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		//NSLog(@"%@", [dataDictionary objectForKey:@"data"]);
		
		for (NSDictionary *item in [dataDictionary objectForKey:@"data"]) {
			//NSLog(@"%@", item);
			StickerRecord *stickerRecord = [[StickerRecord alloc] initWithDictinary:item];
			[self.stickersRecordList addObject:stickerRecord];
		}
		[self.tableView reloadData];
		
	}
	[self.refreshControl endRefreshing];
}

#pragma mark - Refresh Control

- (void)refreshControlRequest
{
	NSLog(@"refreshing...");
	
	//[RefreshControl endRefreshing];
	
	// Update the table
	
	[self parseData];
	
	//[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(testRefreshControl:) userInfo:nil repeats:NO];
	
}

- (void)testRefreshControl:(NSTimer *)timer {
	[self.refreshControl endRefreshing];
}


@end
