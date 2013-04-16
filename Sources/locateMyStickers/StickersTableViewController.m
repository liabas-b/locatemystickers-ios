//
//  StickersTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickersTableViewController.h"

#import "MapViewController.h"
#import "StickerDetailViewController.h"

#import "OptionsRecord.h"
#import "OptionsRecord+Manager.h"

#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

#import "StickerManager.h"

#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

#import "UCTabBarItem.h"
#import "BButton.h"

#import "JsonTools.h"
#import "ConventionTools.h"
#import "AppDelegate.h"

@interface StickersTableViewController ()

@property (nonatomic, strong)NSIndexPath *currentIndexPath;

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
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
	
	
	
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
	/*
	 if ([[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue] == YES) {
	 [[AppDelegate appDelegate].locationManager start];
	 }
	 //
	 if ([[AppDelegate appDelegate].optionsRecord.locatePhoneEnabled boolValue] == YES) {
	 
	 }
	 */
#warning EDIT StickerType
	NSArray *fetchedPhoneStickersRecordObjects = [StickerRecord stickerRecordsOfStickerTypeId:StickerTypeIphone];
	self.myPhoneStickerRecordList = [[NSMutableArray alloc] initWithArray:fetchedPhoneStickersRecordObjects];
	
	//INFO: Stickers
	NSArray *fetchedStickersRecordObjects = [StickerRecord stickerRecordsOfStickerTypeId:StickerTypeSticker];
	self.stickersRecordList = [[NSMutableArray alloc] initWithArray:fetchedStickersRecordObjects];
	
	[self.tableView reloadData];
	/*
	NSRange range = NSMakeRange(0, [self.tableView numberOfSections]);
	NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
	[self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
	 */
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
    return ([self.stickersRecordList count] > 0) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0 && [self.myPhoneStickerRecordList count] > 0)
		return [self.myPhoneStickerRecordList count];
	return [self.stickersRecordList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StickerCell";
    StickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if (!cell) {
        cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	if ([cell isKindOfClass:[StickerCell class]]) {
		NSLog(@"StickersTableViewController: Configure Cell");
		[self configureCell:cell atIndexPath:indexPath];
	}
    // Configure the cell...
    
    return cell;
}

- (void)configureCell:(StickerCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	StickerRecord *stickerRecord = nil;
	if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] > 0)
		stickerRecord = [self.myPhoneStickerRecordList objectAtIndex:indexPath.row];
	else if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] == 0)
		stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
	else if (indexPath.section == 1)
		stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
	
	
	[stickerRecord debug];
	cell.nameLabel.text = stickerRecord.name;
	NSString *timeString = [ConventionTools getDiffTimeInStringFromDate:stickerRecord.createdAt];
	NSLog(@"%s - <%@", __PRETTY_FUNCTION__, timeString);
	timeString = [timeString length] > 0 ? timeString : @"new";
	cell.timeLabel.text = timeString;
	
	if (stickerRecord.isActive)
		cell.activatedImage.backgroundColor = [UIColor greenColor];
	else
		cell.activatedImage.backgroundColor = [UIColor redColor];
	
	
	/*
	 UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
	 
	 backgroundView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
	 //backgroundView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
	 
	 cell.backgroundView = backgroundView;
	 */
	cell.iconLabel.font = [UIFont iconicFontOfSize:24];
	if ([stickerRecord.stickerTypeId intValue] > StickerTypeSticker) {
		
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconPhone];
	}
	else
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconQrcode];
	
	//
	
	
	[cell setDelegate:self];
	
	[cell setFirstStateIconName:@"mathematic-multiply2-icon-white"
                     firstColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
            secondStateIconName:@"editing-delete-icon-white"
                    secondColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
                  thirdIconName:@"lms-icon-white"
                     thirdColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]//[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                 fourthIconName:@"very-basic-globe-icon-white"
                    fourthColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]
				   fithIconName:@"very-basic-refresh-icon-white"
					  fithColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]];
	
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//mapDetail

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	StickerRecord *stickerRecord = [self stickerRecordAtIndexPath:self.currentIndexPath];
	
	if ([[segue identifier] isEqualToString:@"mapDetail"]) {
		MapViewController *mapViewController = [segue destinationViewController];
		
		mapViewController.stickerRecord = stickerRecord;
	}//stickerDetail
	if ([[segue identifier] isEqualToString:@"stickerDetail"]) {
		StickerDetailViewController *stickerDetailViewController = [segue destinationViewController];
		
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
			StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:item];
		}
		[[NSManagedObjectContext defaultContext] saveNestedContexts];
		//TODO: check if we have to fetch for the new/update entry
		[self fetchStickersList];
		//		[self.tableView reloadData];
		
	}
	[self.refreshControl endRefreshing];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath forStickerCell:(StickerCell *)cell {
	StickerRecord *stickerRecord = [self stickerRecordAtIndexPath:self.currentIndexPath];
	if (stickerRecord != nil) {
		//INFO: remove from web service
		[[AppDelegate appDelegate].stickerManager removeStickerRecord:stickerRecord];
		
		//INFO: remove from view
		[self.myPhoneStickerRecordList removeObjectIdenticalTo:stickerRecord];
		[self.stickersRecordList removeObjectIdenticalTo:stickerRecord];
		
		[stickerRecord deleteEntity];
		[[NSManagedObjectContext defaultContext] saveNestedContexts];

		//TODO: delete sticker from webservice
		
		NSLog(@"%@", stickerRecord.stickerTypeId);//2
		
		
		if (([self.myPhoneStickerRecordList count] == 0 && [stickerRecord.stickerTypeId intValue] != 1) ||
			([self.stickersRecordList count] == 0 && [stickerRecord.stickerTypeId intValue] == 1))
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		else {
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
#warning MAY be save db
	}
}

- (StickerRecord *)stickerRecordAtIndexPath:(NSIndexPath *)indexPath {
	StickerRecord *stickerRecord = nil;
	//NSIndexPath *indexPath = self.currentIndexPath;//[self.tableView indexPathForSelectedRow];
	if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] > 0)
		stickerRecord = [self.myPhoneStickerRecordList objectAtIndex:indexPath.row];
	else if (indexPath.section == 0 && [self.myPhoneStickerRecordList count] == 0)
		stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
	else if (indexPath.section == 1)
		stickerRecord = [self.stickersRecordList objectAtIndex:indexPath.row];
	return stickerRecord;
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

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, buttonState);
	
	self.currentIndexPath = [self.tableView indexPathForCell:cell];
	
	NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.currentIndexPath);
	
	switch (buttonState) {
		case MCSwipeTableViewButtonState1:
			break;
		case MCSwipeTableViewButtonState2://INFO: delete sticker
		{
			[self deleteRowAtIndexPath:self.currentIndexPath forStickerCell:cell];
		}
			break;
		case MCSwipeTableViewButtonState3://INFO: sticker detail
		{
			[cell bounceToOrigin];
			[self performSegueWithIdentifier:@"stickerDetail" sender:self];
		}
			break;
		case MCSwipeTableViewButtonState4://INFO: map
		{
			[cell bounceToOrigin];
			[self performSegueWithIdentifier:@"mapDetail" sender:self];
			
		}
			break;
		case MCSwipeTableViewButtonState5://INFO: share
			break;
			
		default:
			break;
	}
}

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
	NSLog(@"%s - %d - %d", __PRETTY_FUNCTION__, state, mode);
	
}


@end
