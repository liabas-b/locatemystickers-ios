//
//  SearchViewController.m
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+Extension.h"

#import "UIViewController+Extension.h"
#import "LMSStickerConfiguration.h"

#import "User+Manager.h"
#import "User.h"

//#import "LMSSticker+Manager.h"
#import "LMSSticker.h"

#import "Stickers+Manager.h"
#import "Stickers.h"

#import "StickerCell.h"

#import "NSDate+helpers.h"

#import "HeaderScanView.h"
#import "StickerDetailViewController.h"


typedef enum
{
    searchScopeCountry = 0,
    searchScopeCapital = 1
    
} UYLWorldFactsSearchScope;



static double kDefaultCellHeight = 80;

static NSString *stickerCellIdentifier = @"StickerCell";

@interface SearchViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Stickers *stickers;
@property (nonatomic, strong) NSMutableArray *stickerList;

@property (nonatomic, strong) NSArray *searchResultList;

@end

@implementation SearchViewController

#pragma mark - Configure

- (void)configure {
	[super configure];
	
	[self configureView];
	[self registerNibs];
	[self setupData];
	[self setupView];
}

#pragma mark - Base logic

- (void)configureView {
	[super configureView];
	
	[self configureMenuLeftButtonWithBackButon:[self.navigationController.viewControllers count] > 1];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.allowsSelection = YES;
	
}

- (void)registerNibs {
	[super registerNibs];
}

- (void)setupData {
	[super setupData];
	
	
	self.stickers = [[Stickers alloc] init];
	
	if (self.user == nil) {
		self.user = [[User alloc] init];
#warning TO IMPLEMENT
		//TODO: get the default id from the session manager
		self.user.id = 1;
	}
	
	
	[self.user update:^(id object) {
		if (object) {
			self.user = (User *)object;
			DLog(@"user: %@", self.user);
			
			self.stickers = [[Stickers alloc] init];
			[self.stickers updateWithUser:self.user andBlock:^(id object) {
				DLog(@"object: %@", object);
				if (object) {
					Stickers *stickers = (Stickers *)object;
					DLog(@"stickers.stickers: %@", stickers.stickers);
					self.stickerList = [[NSMutableArray alloc] initWithArray:stickers.stickers];
					
					[self.tableView reloadData];
					//					[self.mapView loadStickerList:self.stickerList];
					
					//WARNING: bad -> reload only the targeted cell
					//					[self.tableView reloadData];
				}
			}];
		}
	}];
	
}

- (void)setupView {
	[super setupView];
	
}

#pragma mark - View controller life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//    cell.backgroundColor = [UIColor clearColor];
	//	cell.selectedBackgroundView = nil;
	tableView.rowHeight = 80.0;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
	//return [self.stickerList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	
	if (tableView != self.tableView) {//self.searchDisplayController.searchResultsTableView) {
        return [self.searchResultList count];
		
    } else {
        return [self.stickerList count];
        
    }
	
	//	return [self.stickerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	UITableViewCell *defaultCell = [tableView cellForRowAtIndexPath:indexPath];
	DLog(@"defaultCell.reuseIdentifier: %@", defaultCell.reuseIdentifier);
    if ([defaultCell.reuseIdentifier isEqualToString:stickerCellIdentifier])
    {
		StickerCell *cell = (StickerCell *)defaultCell;//[tableView dequeueReusableCellWithIdentifier:stickerCellIdentifier];
		
		if (cell == nil) {
			cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stickerCellIdentifier];
		}
		
		
		[self configure:tableView withCell:cell atIndexPath:indexPath];
		
		//	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
		//	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
		//	/
		//	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
		//	cell.menuLabel.text = [menuItem.controller capitalizedString];
		return cell;
    }
	
	if (defaultCell == nil) {
//		defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCellIdentifier"];
//		defaultCell.textLabel.text = @"hello";
		
		//
		StickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:stickerCellIdentifier];
		
		if (cell == nil) {
			cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stickerCellIdentifier];
		}
		
		
		[self configure:tableView withCell:cell atIndexPath:indexPath];
		
		//	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
		//	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
		//	/
		//	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
		//	cell.menuLabel.text = [menuItem.controller capitalizedString];
		return cell;
		//
	}
	return defaultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LMSSticker *sticker = [self.stickerList objectAtIndex:indexPath.row];
	
	DLog(@"Selected sticker: %@", sticker);
	
	
	StickerDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StickerDetailsController"];
	vc.sticker = sticker;
	[self.navigationController pushViewController:vc animated:YES];
	
	
	
	//	[self performSegueWithIdentifier:@"stickerDetail" sender:self];
}


- (void)configure:(UITableView *)tableView withCell:(StickerCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	LMSSticker *stickerRecord = nil;
	
	if (tableView != self.tableView) {//self.searchDisplayController.searchResultsTableView) {
		stickerRecord = [self.searchResultList objectAtIndex:indexPath.row];
		
    } else {
        stickerRecord = [self.stickerList objectAtIndex:indexPath.row];
    }
	
	DLog(@"stickerRecord: %@", stickerRecord);

	//	LMSSticker *stickerRecord = [self.stickerList objectAtIndex:indexPath.row];
	
	cell.nameLabel.text = stickerRecord.name;
	
	NSString *timeString = [stickerRecord.createdAt distanceOfTimeInWords];//[ConventionTools getDiffTimeInStringFromDate:stickerRecord.createdAt];
	NSLog(@"%s - <%@", __PRETTY_FUNCTION__, timeString);
	timeString = [timeString length] > 0 ? timeString : @"new";
	cell.timeLabel.text = timeString;
	/*
	 if ([stickerRecord.stickerConfiguration.activate)
	 cell.activatedImage.backgroundColor = [UIColor greenColor];
	 else
	 cell.activatedImage.backgroundColor = [UIColor redColor];
	 */
	/*
	 cell.iconLabel.font = [UIFont iconicFontOfSize:24];
	 if (stickerRecord.stickerTypeId > StickerTypeSticker) {
	 cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconPhone];
	 }
	 else
	 cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconQrcode];
	 */
	
	cell.iconLabel.hidden = YES;
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, stickerRecord.color);
	
	cell.colorView.backgroundColor = [UIColor colorFromHexString:stickerRecord.color];
	
	/*
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
	 
	 
	 */
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, buttonState);
	
	//	self.currentIndexPath = [self.tableView indexPathForCell:cell];
	
	//	NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.currentIndexPath);
	
	switch (buttonState) {
		case MCSwipeTableViewButtonState1:
			break;
		case MCSwipeTableViewButtonState2://INFO: delete sticker
		{
			//			[self deleteRowAtIndexPath:self.currentIndexPath forStickerCell:cell];
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
			//[self performSegueWithIdentifier:@"mapDetail" sender:self];
			
		}
			break;
		case MCSwipeTableViewButtonState5://INFO: share with friends
		{
			[cell bounceToOrigin];
			//[self performSegueWithIdentifier:@"FriendsSegue" sender:self];
			
		}
			break;
			
		default:
			break;
	}
}

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
	NSLog(@"%s - %d - %d", __PRETTY_FUNCTION__, state, mode);
	
}


//SEARCH

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	
	//TODO: do != stuff depending the scope
	
	
	NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
	NSString *searchAttribute = @"name";
	
	//	if (scopeOption == searchScopeCapital)
	{
		searchAttribute = @"name";
	}
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
	self.searchResultList = [[NSArray alloc] initWithObjects:[self.stickerList firstObject], nil];//[self.stickerList filteredArrayUsingPredicate:predicate];
																			 //[self.searchResultList setPredicate:predicate];
	DLog(@"self.searchResultList: %@", self.searchResultList);
	
	return;
	
	
	
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"self.name matches[c] %@", searchText];
    
    self.searchResultList = [self.stickerList filteredArrayUsingPredicate:resultPredicate];
	
	DLog(@"self.searchResultList: %@", self.searchResultList);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchForText:(NSString *)searchText scope:(UYLWorldFactsSearchScope)scopeOption
{
	[self filterContentForSearchText:searchText
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
	
	
	/*
	 if (self.managedObjectContext)
	 {
	 NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
	 NSString *searchAttribute = @"name";
	 
	 if (scopeOption == searchScopeCapital)
	 {
	 searchAttribute = @"capital";
	 }
	 
	 NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
	 [self.searchFetchRequest setPredicate:predicate];
	 
	 NSError *error = nil;
	 self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
	 }
	 */
}


//


// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	DLog(@"");
	//	self.
	
	
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
	DLog(@"");
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	DLog(@"");
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	DLog(@"");
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

// called when the table is created destroyed, shown or hidden. configure as necessary.
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
	DLog(@"");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	DLog(@"");
}

// called when table is shown/hidden
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
	DLog(@"");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
	DLog(@"");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	DLog(@"");
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
	DLog(@"");
}

// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
/*
 - (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
 DLog(@"");
 }
 */

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	DLog(@"");
	return YES;
}



//


//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

@end



