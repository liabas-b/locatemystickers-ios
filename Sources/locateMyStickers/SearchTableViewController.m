//
//  SearchTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SearchTableViewController.h"

#import "StickerCell.h"
#import "UserCell.h"

#import "StickerRecord.h"
#import "AccountRecord.h"

#import "JsonTools.h"

#import "UCTabBarItem.h"


@interface SearchTableViewController ()

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
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.searchDisplayController.searchBar.showsScopeBar = NO;
	[self.searchDisplayController.searchBar sizeToFit];
	
	self.searchRecordList = [[NSMutableArray alloc] init];
	self.filteredSearchRecordList = [[NSMutableArray alloc] init];
	/*
	StickerRecord *stickerRecord = [[StickerRecord alloc] init];
	//	stickerRecord.name = @"Est cumque et magnam in at minus recusandae sint.";
	stickerRecord.createdAt = [NSDate date];//@"2013-02-15T08:28:18Z";
	stickerRecord.isActive = NO;
	
	AccountRecord *accountRecord = [[AccountRecord alloc] init];
	accountRecord.name = @"Benoit Liabastre";
	
	[self.searchRecordList addObject:stickerRecord];
	[self.searchRecordList addObject:accountRecord];
	*/
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
}


- (void)configureStickerCell:(StickerCell *)cell withStickerRecord:(StickerRecord*)stickerRecord {
	cell.nameLabel.text = stickerRecord.name;
	cell.timeLabel.text = stickerRecord.createdAt;
	if (stickerRecord.isActive)
		cell.activatedImage.backgroundColor = [UIColor greenColor];
	else
		cell.activatedImage.backgroundColor = [UIColor redColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
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
	searchBar.showsScopeBar = YES;
	[searchBar sizeToFit];
	
	[searchBar setShowsCancelButton:YES animated:YES];
	
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	searchBar.showsScopeBar = NO;
	[searchBar sizeToFit];
	
	[searchBar setShowsCancelButton:NO animated:YES];
	
	return YES;
}

#pragma maek - Search stuff

- (void)handleStartSearchUser:(NSString *)searchText {
	NSString *stringSearchRequest = [NSString stringWithFormat:@"http://web-service.locatemystickers.com/users.json?direction=asc&sort=id&search=%@&column=name", searchText];
	
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:stringSearchRequest]];
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
		//TODO: save file
		if (self.searchRecordList) {
			[self.searchRecordList removeAllObjects];
		}
		
		self.searchRecordList = [[NSMutableArray alloc] init];
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		//NSLog(@"%@", [dataDictionary objectForKey:@"data"]);
		
		for (NSDictionary *item in [dataDictionary objectForKey:@"data"]) {
			//NSLog(@"%@", item);
			AccountRecord *accountRecord = [[AccountRecord alloc] initWithDictinary:item];
			[self.searchRecordList addObject:accountRecord];
		}
		[self.tableView reloadData];
		
	}
}


#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	NSLog(@"searchText: %@", searchText);
	
	[self handleStartSearchUser:searchText];
    //INFO: Update the filtered array based on the search text and scope.
    //INFO: Remove all objects from the filtered search array
    [self.filteredSearchRecordList removeAllObjects];
    //INFO: Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
	
	
	NSArray *tempArray = [self.searchRecordList filteredArrayUsingPredicate:predicate];
	NSLog(@"%@", tempArray);
	/*
	 if (![scope isEqualToString:@"All"]) {
	 // Further filter the array with the scope
	 NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",scope];
	 tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
	 }
	 */
    self.filteredSearchRecordList = [NSMutableArray arrayWithArray:tempArray];
	
	//    self.filteredSearchRecordList = self.searchRecordList;//[NSMutableArray arrayWithArray:[self.searchRecordList filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    //INFO: Tells the table data source to reload when text changes
	
	NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
	NSLog(@"categoryName: %@", categoryName);
    [self filterContentForSearchText:searchString scope:categoryName];
    //INFO: Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    //INFO: Tells the table data source to reload when scope bar selection changes
	NSString *categoryName = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
	NSLog(@"categoryName: %@", categoryName);
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
@end
