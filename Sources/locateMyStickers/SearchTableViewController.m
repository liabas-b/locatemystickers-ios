//
//  SearchTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SearchTableViewController.h"

#import "MapViewController.h"

#import "StickerDetailViewController.h"

#import "StickerCell.h"
#import "UserCell.h"

#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

#import "AccountRecord.h"
#import "AccountRecord+Manager.h"

#import "JsonTools.h"

#import "UCTabBarItem.h"

#import "AppDelegate.h"
#import "SessionManager.h"

#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

#import "UIImageView+AFNetworking.h"
#import "CryptographyTools.h"

#import "ConventionTools.h"

#import "UIColor+Colours.h"

@interface SearchTableViewController ()

@property (nonatomic, strong)NSIndexPath *currentIndexPath;

@end

@implementation SearchTableViewController

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
	
	self.searchDisplayController.searchBar.showsScopeBar = NO;
	[self.searchDisplayController.searchBar sizeToFit];
	
	self.searchRecordList = [[NSMutableArray alloc] init];
	self.filteredSearchRecordList = [[NSMutableArray alloc] init];
	
	[self setup];
	
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"Search"
											imageSelected:@"search_black"
											andUnselected:@"search_white"];
}

- (void)setup {
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]];
    [self.tableView setBackgroundView:backgroundView];
}

- (id)stickerRecordAtIndexPath:(NSIndexPath *)indexPath {
	id dataRecord = nil;
	//if (tableView == self.searchDisplayController.searchResultsTableView ) {
        dataRecord = [self.filteredSearchRecordList objectAtIndex:indexPath.row];
//    } else {
//        dataRecord = [self.searchRecordList objectAtIndex:indexPath.row];
//    }
	return dataRecord;
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
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredSearchRecordList count];
	} else {
		return [self.searchRecordList count];
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id dataRecord = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataRecord = [self.filteredSearchRecordList objectAtIndex:indexPath.row];
    } else {
        dataRecord = [self.searchRecordList objectAtIndex:indexPath.row];
    }
	
	if ([dataRecord isKindOfClass:[StickerRecord class]]) {
		StickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StickerCell" forIndexPath:indexPath];
		[self configureStickerCell:cell withStickerRecord:dataRecord];//atIndexPath:indexPath];
		return cell;
	} else {
		UserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
		[self configureUserCell:cell withAccountRecord:dataRecord];//atIndexPath:indexPath];
		return cell;
	}
	
	return nil;
}

#pragma mark - configure cell

- (void)configureUserCell:(UserCell *)cell withAccountRecord:(AccountRecord*)accountRecord {
	cell.userNameLabel.text = accountRecord.name;
	cell.stickersNumberLabel.text = @"42";
	
	[cell setDelegate:self];
	
	[cell setFirstStateIconName:@"mathematic-multiply2-icon-white"
                     firstColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
            secondStateIconName:@"user.png"
                    secondColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
                  thirdIconName:@"userAddFriend"
                     thirdColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]//[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                 fourthIconName:@"message"
                    fourthColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]];
	
	
	NSString *hashGravatar = [CryptographyTools stringToMD5:accountRecord.email];
	NSString *gravatarUrl = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", hashGravatar];
	
	[cell.profileImageView setImageWithURL:[NSURL URLWithString:gravatarUrl] placeholderImage:[UIImage imageNamed:@"locateMyStickersFushiaSmallLogo"]];

	
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)configureStickerCell:(StickerCell *)cell withStickerRecord:(StickerRecord*)stickerRecord {
	cell.nameLabel.text = stickerRecord.name;
	if (stickerRecord.isActive)
		cell.activatedImage.backgroundColor = [UIColor greenColor];
	else
		cell.activatedImage.backgroundColor = [UIColor redColor];
	
	
	cell.timeLabel.text = [ConventionTools getDiffTimeInStringFromDate:stickerRecord.createdAt];//[stickerRecord.createdAt description];
	
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
	if ([stickerRecord.stickerTypeId intValue] > StickerTypeSticker) {//1
		
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconPhone];
	}
	else
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconQrcode];
	
	
	cell.colorView.backgroundColor = [UIColor colorFromHexString:stickerRecord.color];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;
}

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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	//	searchBar.showsScopeBar = YES;
	//	[searchBar sizeToFit];
	
	[self.searchDisplayController setActive:YES animated:YES];
	[searchBar setShowsCancelButton:YES animated:YES];
	
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	//TODO: maybe cancel current request
	//	searchBar.showsScopeBar = NO;
	//	[searchBar sizeToFit];
	[self.searchDisplayController setActive:NO animated:YES];
	//	self.searchDisplayController.searchBar.showsScopeBar = NO;
	//	[self.searchDisplayController.searchBar sizeToFit];
	
	
	[searchBar setShowsCancelButton:NO animated:YES];
	
	return YES;
}

#pragma maek - Search stuff

- (void)handleStartSearchUsers:(NSString *)searchText {
	
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	NSString *requestString = [NSString stringWithFormat:@"%@/users.json?direction=asc&sort=id&search=%@&column=name", hostName, searchText];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	//	NSURLResponse *response;
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveAccountData:data forSearchText:searchText];
	}];
	
}

- (void)handleStartSearchStickers:(NSString *)searchText {
	
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	//INFO:user set in hard
	NSString *requestString = [NSString stringWithFormat:@"%@/users/3/stickers.json?direction=asc&sort=id&search=%@&column=name", hostName, searchText];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	/*
	 NSURLResponse *response;
	 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];//sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
	 [self didReceiveStickerData:data forSearchText:searchText];
	 */
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveStickerData:data forSearchText:searchText];
	}];
}

- (void)didReceiveAccountData:(NSData *)data forSearchText:(NSString *)searchText {
	//INFO: debug
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		//TODO: save file
		NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
		NSLog(@"categoryName: %@", categoryName);
		
		if (self.searchRecordList && ![categoryName isEqualToString:@"Everything"]) {
			[self.searchRecordList removeAllObjects];
		}
		
		NSArray *dataArray = [JsonTools getArrayFromData:data];
		if (dataArray) {
			for (NSDictionary *item in dataArray) {
				NSLog(@"--|--%@--|--", item);
				AccountRecord *accountRecord = [AccountRecord addUpdateWithDictionary:item];
				if (accountRecord)
					[self.searchRecordList addObject:accountRecord];
			}
		}
		
		//INFO: Filter the array using NSPredicate
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
		
		NSArray *tempArray = [self.searchRecordList filteredArrayUsingPredicate:predicate];
		NSLog(@"%@", tempArray);
		self.filteredSearchRecordList = [NSMutableArray arrayWithArray:tempArray];
		
		[self.searchTableView reloadData];
		[self.tableView reloadData];
	}
}

- (void)didReceiveStickerData:(NSData *)data forSearchText:(NSString *)searchText {
	//INFO: debug
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		//TODO: save file
		NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
		//NSLog(@"categoryName: %@", categoryName);
		if (self.searchRecordList && ![categoryName isEqualToString:@"Everything"]) {
			[self.searchRecordList removeAllObjects];
		}
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		if (dataDictionary) {
			for (NSDictionary *item in dataDictionary) {
				NSLog(@"--|--%@--|--", item);
				if (item != nil) {
					StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:item];
					if (stickerRecord != nil)
						[self.searchRecordList addObject:stickerRecord];
				}
			}
		}
		
		//INFO: Filter the array using NSPredicate
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
		
		NSArray *tempArray = [self.searchRecordList filteredArrayUsingPredicate:predicate];
		NSLog(@"%@", tempArray);
		self.filteredSearchRecordList = [NSMutableArray arrayWithArray:tempArray];
		
		[self.searchTableView reloadData];
		[self.tableView reloadData];
	}
}



#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	NSLog(@"searchText: %@", searchText);
	
	NSLog(@"scope: %@", scope);
	
	[self.filteredSearchRecordList removeAllObjects];
	
	if ([scope isEqualToString:@"Stickers"])
		[self handleStartSearchStickers:searchText];
	else if ([scope isEqualToString:@"People"])
		[self handleStartSearchUsers:searchText];
	else {
		[self.searchRecordList removeAllObjects];
		
		[self handleStartSearchStickers:searchText];
		[self handleStartSearchUsers:searchText];
	}
	
	
    //INFO: Filter the array using NSPredicate
    /*
	 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
	 
	 NSArray *tempArray = [self.searchRecordList filteredArrayUsingPredicate:predicate];
	 NSLog(@"%@", tempArray);
	 self.filteredSearchRecordList = [NSMutableArray arrayWithArray:tempArray];
	 */
}

#pragma mark - UISearchDisplayController Delegate Methods
// searchDisplayController:didLoadSearchResultsTableView
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	self.searchTableView = tableView;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    //INFO: Tells the table data source to reload when text changes
	
	NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
	NSLog(@"searchDisplayController 1 categoryName: %@", categoryName);
    [self filterContentForSearchText:searchString scope:categoryName];
    //INFO: Return YES to cause the search result table view to be reloaded.
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    //INFO: Tells the table data source to reload when scope bar selection changes
	NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
	NSLog(@"searchDisplayController 2 categoryName: %@", categoryName);
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:categoryName];
    //INFO: Return YES to cause the search result table view to be reloaded.
    return YES;
}
/*
 -(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
 // Update the filtered array based on the search text and scope.
 // Remove all objects from the filtered search array
 [self.filteredCandyArray removeAllObjects];
 // Filter the array using NSPredicate
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
 NSArray *tempArray = [candyArray filteredArrayUsingPredicate:predicate];
 if (![scope isEqualToString:@"All"]) {
 // Further filter the array with the scope
 NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
 tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
 }
 filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
 }
 */

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	
	if ([[segue identifier] isEqualToString:@"mapDetail"]) {
		StickerRecord *stickerRecord = [self stickerRecordAtIndexPath:self.currentIndexPath];
		MapViewController *mapViewController = [segue destinationViewController];
		
		mapViewController.stickerRecord = stickerRecord;
	}//stickerDetail
	if ([[segue identifier] isEqualToString:@"stickerDetail"]) {
		StickerRecord *stickerRecord = [self stickerRecordAtIndexPath:self.currentIndexPath];
		
		StickerDetailViewController *stickerDetailViewController = [segue destinationViewController];
		
		stickerDetailViewController.stickerRecord = stickerRecord;
	}
}

#pragma mark - MCSwipeStickerTableViewCellDelegate

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, buttonState);
	
	self.currentIndexPath = [self.tableView indexPathForCell:cell];
	
	NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.currentIndexPath);
	
	switch (buttonState) {
		case MCSwipeTableViewButtonState1:
			break;
		case MCSwipeTableViewButtonState2://INFO: delete sticker
		{
			//[self deleteRowAtIndexPath:self.currentIndexPath forStickerCell:cell];
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

#pragma mark - MCSwipeUserTableViewCellDelegate

- (void)swipeUserTableViewCell:(UserCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, buttonState);
	
	self.currentIndexPath = [self.tableView indexPathForCell:cell];
	
	NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.currentIndexPath);
	
	switch (buttonState) {
		case MCSwipeTableViewButtonState1:
			break;
		case MCSwipeTableViewButtonState2://INFO: delete sticker
		{
			//[self deleteRowAtIndexPath:self.currentIndexPath forStickerCell:cell];
		}
			break;
		case MCSwipeTableViewButtonState3://INFO: sticker detail
		{
			[cell bounceToOrigin];
			//[self performSegueWithIdentifier:@"stickerDetail" sender:self];
		}
			break;
		case MCSwipeTableViewButtonState4://INFO: map
		{
			[cell bounceToOrigin];
			//[self performSegueWithIdentifier:@"mapDetail" sender:self];
		}
			break;
		case MCSwipeTableViewButtonState5://INFO: share
			break;
			
		default:
			break;
	}
}

- (void)swipeUserTableViewCell:(UserCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
	NSLog(@"%s - %d - %d", __PRETTY_FUNCTION__, state, mode);
	
}

@end
