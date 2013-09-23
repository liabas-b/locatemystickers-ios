//
//  FriendsViewController.m
//  LMS
//
//  Created by Adrien Guffens on 9/20/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "FriendsViewController.h"

#import "AccountRecord.h"
#import "AccountRecord+Manager.h"
#import "CryptographyTools.h"

#import "FriendCell.h"

#import "JsonTools.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"

#import "CryptographyTools.h"
#import "AppDelegate.h"

@interface FriendsViewController ()

@property (nonatomic, strong)NSMutableArray *friendList;

@end

@implementation FriendsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.rowHeight = 80.0;
	
	self.friendList = [[NSMutableArray alloc] init];
	[self updateFriendList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateFriendList {
	
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:@"friends"];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"Result: %@", JSON);
		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			AccountRecord *accountRecord = [AccountRecord addUpdateWithDictionary:dic];
			NSLog(@" %s| accountRecord: %@", __PRETTY_FUNCTION__, accountRecord);
			[self.friendList addObject:accountRecord];
		}
		[self.tableView reloadData];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	[operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	AccountRecord *accountRecord = [self.friendList objectAtIndex:indexPath.row];
	[self configureUserCell:cell withAccountRecord:accountRecord];
    
    // Configure the cell...
	
    
    return cell;
}

- (void)configureUserCell:(FriendCell *)cell withAccountRecord:(AccountRecord*)accountRecord {
	cell.userNameLabel.text = accountRecord.name;
	cell.stickersNumberLabel.text = @"42";
	
	NSString *hashGravatar = [CryptographyTools stringToMD5:accountRecord.email];
	NSString *gravatarUrl = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", hashGravatar];
	
	[cell.profileImageView setImageWithURL:[NSURL URLWithString:gravatarUrl] placeholderImage:[UIImage imageNamed:@"locateMyStickersFushiaSmallLogo"]];
	
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self shareSticker];
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)shareSticker {
	//TODO: send request to share
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
