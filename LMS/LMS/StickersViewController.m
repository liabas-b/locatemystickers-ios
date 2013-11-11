//
//  StickersViewController.m
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "StickersViewController.h"
#import "UIViewController+Extension.h"
#import "LMSStickerConfiguration.h"

#import "StickerCell.h"

static double kDefaultCellHeight = 80;

static NSString *stickerCellIdentifier = @"StickerCell";

@interface StickersViewController ()

@property (nonatomic, strong) NSMutableArray *stickerList;

@end

@implementation StickersViewController

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
	
	self.stickerList = [[NSMutableArray alloc] init];
	
	[self.stickerList addObject:@"Hello"];
	[self.stickerList addObject:@"Hello"];
	[self.stickerList addObject:@"Hello"];
	[self.stickerList addObject:@"Hello"];
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
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.stickerList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	return [self.stickerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    StickerCell *cell = [tableView dequeueReusableCellWithIdentifier:stickerCellIdentifier];
    
    if (cell == nil) {
        cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stickerCellIdentifier];
    }
	
//	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
//	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
//	/
//	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
//	cell.menuLabel.text = [menuItem.controller capitalizedString];
    
    return cell;
}

@end
