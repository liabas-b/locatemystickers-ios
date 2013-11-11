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

#import "TopMenuView.h"


static double kDefaultHeaderHeight = 34;
static double kDefaultCellHeight = 60;

static NSString *menuCellIdentifier = @"MenuCell";

@interface LMSMenuViewController ()

@property (nonatomic, strong) NSMutableArray *menuList;
@property (nonatomic, strong) NSMutableArray *sectionsList;

@end

@implementation LMSMenuViewController

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
	
	self.sectionsList = self.appDelegate.appParameters.sectionsList;
	self.menuList = self.appDelegate.appParameters.menuList;
}

- (void)setupView {
	[super setupView];
	
	self.topView.appNameLabel.text = self.appDelegate.appParameters.parameters.appName;
	self.topView.appImageView.image = [UIImage imageNamed:@"lms-300.png"];
	
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//    cell.backgroundColor = [UIColor clearColor];
	//	cell.selectedBackgroundView = nil;
	//    cell.textLabel.textColor = //[UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
	//    cell.textLabel.font = [UIfo];//[UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex {
	
	SectionMenuItem *sectionMenuItem = [self.sectionsList objectAtIndex:sectionIndex];
	DLog(@"sectionMenuItem: %@", sectionMenuItem);
	
	if ([sectionMenuItem.name length] == 0)
		return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kDefaultHeaderHeight)];
    view.backgroundColor = [UIColor wheatColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 0, 0)];
    label.text = sectionMenuItem.name;
    label.font = [UIFont defaultFont];
    label.textColor = [UIColor defaultTitleColor];
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
	
    return kDefaultHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
	
	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
	
	if (menuItem && menuItem.controller && [menuItem .controller length]) {
		//TODO: check if the identifer exist
		DLog(@"menuItem: %@", menuItem);
		UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:menuItem.controller];
		viewController.title = NSLocalizedString(menuItem.name, @"Title");
		
        navigationController.viewControllers = @[viewController];
	}
	
    [self.frostedViewController hideMenuViewController];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultCellHeight;
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
	
	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
	cell.menuLabel.text = NSLocalizedString(menuItem.name, @"Title");
    
    return cell;
}

#pragma mark - Bottom Menu

- (IBAction)helpHandler:(id)sender {
	
	[self.frostedViewController hideMenuViewController];
	
	UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
	[navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"helpController"] animated:YES];

}

- (IBAction)settingsHandler:(id)sender {
	[self.frostedViewController hideMenuViewController];
	
	UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
	[navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"settingsController"] animated:YES];
	
}

- (IBAction)logoutHandler:(id)sender {
	[self.frostedViewController hideMenuViewController];
	
	UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
	[navigationController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginController"] animated:YES completion:^{
		DLog(@"logout");
	}];
	
}

@end
