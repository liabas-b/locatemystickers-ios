//
//  HistoriesViewController.m
//  LMS
//
//  Created by Adrien Guffens on 9/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "HistoriesViewController.h"
#import "HistoryRecord+Manager.h"
#import "HistoryCell.h"

#import "ConventionTools.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"

#import "UIViewController+Extension.h"

@interface HistoriesViewController ()

@property (nonatomic, strong) NSMutableArray *historyList;

@end

@implementation HistoriesViewController

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

	[self configureMenuLeftButtonWithBackButon:[self.navigationController.viewControllers count] > 1];

	self.historyList = [[NSMutableArray alloc] init];
	
	[self updateHistories];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Service Histories request

- (void)updateHistories {
	
	NSString *route = @"histories";
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"Result: %@", JSON);
		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			HistoryRecord *historyRecord = [HistoryRecord addUpdateHistoryWithDictionary:dic];
			NSLog(@" %s| historyRecord: %@", __PRETTY_FUNCTION__, historyRecord);
			if (![self.historyList containsObject:historyRecord]) {
				[self.historyList addObject:historyRecord];
				[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.historyList count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
			}
		}
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	[operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.historyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryCell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	
	HistoryRecord *historyRecord = [self.historyList objectAtIndex:indexPath.row];
	
	NSString *historyText = [NSString stringWithFormat:@"%@ was %@", [historyRecord.subject capitalizedString], historyRecord.operation];

	dispatch_async(dispatch_get_main_queue(), ^{
		cell.historyLabel.text = historyText;
		cell.dateLabel.text = [ConventionTools getDiffTimeInStringFromDate:historyRecord.updatedAt];
    });
    return cell;
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
