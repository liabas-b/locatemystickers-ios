//
//  FriendsViewController.m
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "FriendsViewController.h"
#import "UIViewController+Extension.h"
#import "User.h"
#import "User+Manager.h"

#import "Friends.h"
#import "Friends+Manager.h"

@interface FriendsViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Friends *friends;
@property (nonatomic, strong) NSMutableArray *friendList;

@end

@implementation FriendsViewController

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
//			[self.topView configureWithUser:self.user];
			
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
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
	//return [self.stickerList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	return [self.friendList count];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier::@"FriendCell"];
    

    StickerCell *cell = [tableView dequeueReusableCellWithIdentifier:stickerCellIdentifier];
    
    if (cell == nil) {
        cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stickerCellIdentifier];
    }

//	[self configureCell:cell atIndexPath:indexPath];
	//	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
	//	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
	//	/
	//	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
	//	cell.menuLabel.text = [menuItem.controller capitalizedString];
    
    return cell;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	LMSSticker *sticker = [self.stickerList objectAtIndex:indexPath.row];
	
	DLog(@"Selected cell");
	//	[self performSegueWithIdentifier:@"stickerDetail" sender:self];
}

@end
