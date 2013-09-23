//
//  AccountViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/28/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "AccountViewController.h"

#import "AccountRecord.h"
#import "AccountRecord+Manager.h"

#import "JsonTools.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"

#import "CryptographyTools.h"
#import "AppDelegate.h"

@interface AccountViewController ()

@property(nonatomic, strong)AccountRecord *accountRecord;

@end

@implementation AccountViewController

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
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];

	[self updateAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Service User request

- (void)updateAccount {
	
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:nil];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"Result: %@", JSON);
		
		NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, JSON);
		self.accountRecord = [AccountRecord addUpdateWithDictionary:JSON];
		NSLog(@" %s| accountRecord: %@", __PRETTY_FUNCTION__, self.accountRecord);
		
		[self updateView];

		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	[operation start];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - view

- (void)updateView {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.nameTextField.text = self.accountRecord.name;
		self.emailTextField.text = self.accountRecord.email;
		
		NSString *hashGravatar = [CryptographyTools stringToMD5:self.accountRecord.email];
		NSString *gravatarUrl = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", hashGravatar];

		[self.profileImageView setImageWithURL:[NSURL URLWithString:gravatarUrl] placeholderImage:[UIImage imageNamed:@"locateMyStickersFushiaSmallLogo"]];
	});
}

- (void)hideKeyboard:(NSNotification *)notification {
	if ([self.nameTextField isFirstResponder])
		[self.nameTextField resignFirstResponder];
	else if ([self.emailTextField isFirstResponder])
		[self.emailTextField resignFirstResponder];
	
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}


@end
