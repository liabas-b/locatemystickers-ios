//
//  LMSMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "LMSMenuViewController.h"
#import "LMSHomeViewController.h"
#import "LMSSecondViewController.h"
#import "LMSMapViewController.h"
#import "UIViewController+REFrostedViewController.h"

#import "UserTableViewController.h"
#import "StickersTableViewController.h"

#import "LMSMenuCell.h"
#import "AppDelegate.h"

#import "LMSTableView.h"
#import "LMSLabel.h"

static NSString *menuCellIdentifier = @"MenuCell";

@interface LMSMenuViewController ()

@property (nonatomic, strong) NSMutableArray *menuList;
@property (nonatomic, strong) NSMutableArray *sectionsList;


@end

@implementation LMSMenuViewController

#pragma mark - Configure

- (void)configure {
	[super configure];
////	self.screenName = [[self class] description];
	
	[self configureView];
	[self registerNibs];
	[self setupData];
	[self setupView];
}

#pragma mark - Base logic

- (void)configureView {
    [super configureView];
	
	self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)registerNibs {
    [super registerNibs];
}

- (void)setupData {
	[super setupData];
	
	DLog(@"self.appDelegate.appParameters.parameters.sectionsMenu: %@", self.appDelegate.appParameters.parameters.sectionsMenu);
	
	NSMutableArray *sectionsMenu = [[NSMutableArray alloc] initWithArray:self.appDelegate.appParameters.parameters.sectionsMenu];
	
	[sectionsMenu enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SectionMenuItem *sectionMenu = (SectionMenuItem *)obj;
		if (sectionMenu.section == -1)
			[sectionsMenu removeObject:sectionMenu];
	}];
	
	NSArray *sortedSectionsMenu = [sectionsMenu sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(id obj1, id obj2) {
		int section1 = ((SectionMenuItem *)obj1).section;
		int section2 = ((SectionMenuItem *)obj2).section;
		
		if (section1 == section2) return NSOrderedSame;
		return (section1 < section2) ? NSOrderedAscending : NSOrderedDescending;
	}];
	
	DLog(@"sortedSectionsMenu:");
	[sortedSectionsMenu enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		DLog(@"obj: %@ | idx: %d", obj, idx);
	}];
	
	self.sectionsList = [[NSMutableArray alloc] initWithArray:sortedSectionsMenu];
	
	self.menuList = [[NSMutableArray alloc] init];
	
	for (SectionMenuItem *sectionMenuItem in sortedSectionsMenu) {
		DLog(@"sectionMenuItem: %@", [sectionMenuItem description]);
		NSMutableArray *rows = [[NSMutableArray alloc] init];
		NSArray *menusItem = self.appDelegate.appParameters.parameters.menu;
		for (MenuItem *menuItem in menusItem) {
			if (menuItem.section == sectionMenuItem.section) {
				DLog(@"add object: %@", menuItem);
				[rows addObject:menuItem];
			}
		}
		[self.menuList addObject:rows];
	}
	
	DLog(@"sectionsMenuList: %@", self.menuList);
	
}

- (void)setupView {
	[super setupView];
	
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
//	[self configure];
//	[self.view setNeedsDisplay];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
	//    cell.textLabel.textColor = //[UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
	//    cell.textLabel.font = [UIfo];//[UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Settings";
    label.font = [UIFont defaultFont];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex {
	SectionMenuItem *sectionMenuItem = [self.sectionsList objectAtIndex:sectionIndex];
	DLog(@"sectionMenuItem: %@", sectionMenuItem);
	
	if ([sectionMenuItem.name length] == 0)
		return 0;
	
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
	
	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
	
	if (menuItem && menuItem.controller && [menuItem .controller length]) {
		//TODO: check if the identifer exist
		DLog(@"menuItem: %@", menuItem);
		NSString *controllerIdentifier = [NSString stringWithFormat:@"%@Controller", menuItem.controller];
        navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:controllerIdentifier]];
	}

    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	NSArray *currentMenuList = [self.menuList objectAtIndex:sectionIndex];
	
	return [currentMenuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    LMSMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    
    if (cell == nil) {
        cell = [[LMSMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuCellIdentifier];
    }
	
	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
	cell.textLabel.text = [menuItem.controller capitalizedString];
    
    return cell;
}

@end
