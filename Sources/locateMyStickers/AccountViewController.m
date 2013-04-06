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

#import "AppDelegate.h"

@interface AccountViewController ()

@property(nonatomic, strong)AccountRecord *accoutRecord;

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
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	
	[self parseData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view

- (void)updateView {
	self.nameTextField.text = self.accoutRecord.name;
	self.emailTextField.text = self.accoutRecord.email;
}

- (void)hideKeyboard:(NSNotification *)notification {
	if ([self.nameTextField isFirstResponder])
		[self.nameTextField resignFirstResponder];
	else if ([self.emailTextField isFirstResponder])
		[self.emailTextField resignFirstResponder];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:YES];
}


#pragma mark - data parsing

- (void)parseData
{
	
    // TODO: Create an Operation Queue [OK]
	
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	NSString *requestString = [NSString stringWithFormat:@"%@/users/3.json", hostName];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];

	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveData:data];
	}];
}

- (void)didReceiveData:(NSData *)data {
	//INFO: debug
	
	if (data) {
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"------ <%@>", dataString);
	}
	else
		NSLog(@"BAD");
	
	
	if (data) {
		//TODO: save file
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		if (dataDictionary) {
			self.accoutRecord = [AccountRecord addUpdateAccountWithDictionary:dataDictionary managedObjectContext:[AppDelegate appDelegate].managedObjectContext];//[[AccountRecord alloc] initWithDictinary:dataDictionary];
			
			[self updateView];
		}
	}
}

@end
