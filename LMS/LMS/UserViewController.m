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

//INFO: MODEL
#import "User.h"
#import "User+Manager.h"
#import "Friends.h"
#import "Friends+Manager.h"

#import <REFrostedViewController.h>

#import "UserToolsView.h"

static double kDefaultCellHeight = 80;

static double kToolsCellHeight = 60;
static double kQRCellHeight = 80;
static double kFriendsCellHeight = 166;

static NSString *lmsCellIdentifier = @"LMSCell";
static NSString *toolsCellIdentifier = @"ToolsCell";
static NSString *qrCellIdentifier = @"QRCell";
static NSString *friendsCellIdentifier = @"FriendsCell";

@interface UserViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Friends *friends;
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
	[self.menuList addObject:@"tools"];
	[self.menuList addObject:@"qr"];
	[self.menuList addObject:@"friend"];
}

- (void)registerNibs {
	[super registerNibs];
}

- (void)setupData {
	[super setupData];
	
	self.friendList = [[NSMutableArray alloc] init];
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
			[self.topView configureWithUser:self.user];
			
			//INFO: Friends
			self.friends = [[Friends alloc] init];
			
			[self.friends updateWithUser:self.user andBlock:^(id object) {
				DLog(@"object: %@", object);
				if (object) {
					Friends *friends = (Friends *)object;
					DLog(@"friends.friends: %@", friends.friends);
					self.friendList = [[NSMutableArray alloc] initWithArray:friends.friends];
					//WARNING: bad -> reload only the targeted cell
					[self.tableView reloadData];
				}
			}];

		}
	}];
	
	
	
	
	
	
	

	

/*
	[self.friendList addObject:@"adril"];
	[self.friendList addObject:@"ben"];
	[self.friendList addObject:@"hermes"];
	
	[self.friendList addObject:@"denis"];
	[self.friendList addObject:@"sylvain"];
	[self.friendList addObject:@"yann"];
	[self.friendList addObject:@"irfane"];
 */
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
			result = kToolsCellHeight;
		}
			break;
			
		case 1:
		{
			result = kQRCellHeight;
		}
			break;
		case 2:
		{
			result = kFriendsCellHeight;
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
			cell.userToolsView.userToolsCollectionView.touchHandler = ^(NSString *identifier) {
				DLog(@"identifier: %@", identifier);

				UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;

				UIViewController *viewController = nil;
				
				if ([identifier isEqualToString:@"following"]) {
					viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StickersController"];
					viewController.title = NSLocalizedString(@"Following", @"Title");
				} else if ([identifier isEqualToString:@"followers"]) {
					viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StickersController"];
					viewController.title = NSLocalizedString(@"Followers", @"Title");
				}  else if ([identifier isEqualToString:@"stickers"]) {
					viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StickersController"];
					viewController.title = NSLocalizedString(@"Stickers", @"Title");
				}
				
				if (navigationController && viewController) {
					[navigationController pushViewController:viewController animated:YES];
				}
			};
			//
			[self addDividerToView:cell.contentView atLocation:0.0];
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
			[cell configureQrCodeWithValue:@"LMS"];
			[self addDividerToView:cell.contentView atLocation:0.0];
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
			[cell configureWithFriendList:self.friendList];
			cell.friendsCollectionView.touchHandler = ^(id object) {
				DLog(@"object: %@", object);
				if (object) {
					User *friend = (User *)object;
					UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
					UserViewController *friendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserController"];
					friendViewController.title = NSLocalizedString(@"Friends", @"Title");
					friendViewController.user = friend;
					[navigationController pushViewController:friendViewController animated:YES];

				}
				};

			[self addDividerToView:cell.contentView atLocation:0.0];
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
			[self addDividerToView:cell.contentView atLocation:0.0];
			//
			return cell;
		}
			break;
	}
	
	return [tableView dequeueReusableCellWithIdentifier:lmsCellIdentifier];
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
