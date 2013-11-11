//
//  UserViewController.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UserViewController.h"
#import "UIViewController+Extension.h"
#import "LMSCell.h"
#import "QRCell.h"
#import "FriendsCell.h"
#import "ToolsCell.h"

static double kDefaultCellHeight = 80;

static NSString *lmsCellIdentifier = @"LMSCell";
static NSString *toolsCellIdentifier = @"ToolsCell";
static NSString *qrCellIdentifier = @"QRCell";
static NSString *friendsCellIdentifier = @"FriendsCell";

@interface UserViewController ()

@property (nonatomic, strong) NSMutableArray *menuList;
@property (nonatomic, strong) NSMutableArray *friendList;

@end

@implementation UserViewController

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
	
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.allowsSelection = YES;
	
	self.menuList = [[NSMutableArray alloc] init];
	[self.menuList addObject:@"World"];
	[self.menuList addObject:@"World"];
	[self.menuList addObject:@"World"];
	
}

- (void)registerNibs {
	[super registerNibs];
}

- (void)setupData {
	[super setupData];
	
	self.friendList = [[NSMutableArray alloc] init];
	
	[self.friendList addObject:@"Hello"];
	[self.friendList addObject:@"Hello"];
	[self.friendList addObject:@"Hello"];
}

- (void)setupView {
	[super setupView];
	
	[self.tableView reloadData];
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
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat result;
	int row = indexPath.row;
	
	switch (row) {
		case 0:
		{
			result = 60;
		}
			break;
			
		case 1:
		{
			result = 80;
		}
			break;
		case 2:
		{
			result = 166;
		}
			break;
		default:
		{
			result = kDefaultCellHeight;
		}
			break;
	}
    
	return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	return [self.menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = indexPath.row;
	
	switch (row) {
		case 0:
		{
			ToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:toolsCellIdentifier];
			
			if (cell == nil) {
				cell = [[ToolsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:toolsCellIdentifier];
			}
			//
			return cell;
			
		}
			break;
			
		case 1:
		{
			QRCell *cell = [tableView dequeueReusableCellWithIdentifier:qrCellIdentifier];
			
			if (cell == nil) {
				cell = [[QRCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qrCellIdentifier];
			}
			//
			return cell;
			
		}
			break;
		case 2:
		{
			FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsCellIdentifier];
			
			if (cell == nil) {
				cell = [[FriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendsCellIdentifier];
			}
			//
			return cell;
			
		}
			break;
		default:
		{
			LMSCell *cell = [tableView dequeueReusableCellWithIdentifier:lmsCellIdentifier];
			
			if (cell == nil) {
				cell = [[LMSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lmsCellIdentifier];
			}
			//
			return cell;
		}
			break;
	}
	
	return nil;
	/*
	 StickerCell *cell = [tableView dequeueReusableCellWithIdentifier:stickerCellIdentifier];
	 
	 if (cell == nil) {
	 cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stickerCellIdentifier];
	 }
	 */
	//	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
	//	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
	//	/
	//	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
	//	cell.menuLabel.text = [menuItem.controller capitalizedString];
    
	//    return [[UITableViewCell alloc] initWithStyle]
}

#pragma mark -
#pragma mark UI Helpers - To move in an extensison file

- (void)styleFriendProfileImage:(UIImageView*)imageView withImageNamed:(NSString*)imageName andColor:(UIColor*)color{
    
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.cornerRadius = 35.0f;
}

- (void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}

@end
