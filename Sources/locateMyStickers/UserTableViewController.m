//
//  UserTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "UserTableViewController.h"
#import "StickerRecord.h"
#import "UCTabBarItem.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSNumber *yourStickersNumber = [StickerRecord numberOfEntities];
	
	NSString *yourStickersString = [NSString stringWithFormat:@"Your stickers (%@)", yourStickersNumber];
	self.yourStickersLabel.text = yourStickersString;
	
#warning TO IMPLEMENT sharring stickers number
	NSPredicate *predicate = nil;
	int sharringStickersNumber = 2;//[StickerRecord numberOfEntitiesWithPredicate:predicate];
	
	NSString *sharringStickersString = [NSString stringWithFormat:@"Sharring stickers (%d)", sharringStickersNumber];
	self.sharringStickersLabel.text = sharringStickersString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"User"
											imageSelected:@"account_black"
											andUnselected:@"account_white"];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundColor:[UIColor whiteColor]];
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

@end
