//
//  BaseTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 9/17/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

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
	
	//INFO: Background
	
	//INFO: iOS 7
	[self.view setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
	//INFO: iOS 6
	/*
	 UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	 [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]];
	 [self.tableView setBackgroundView:backgroundView];
	 */
	if (self.refreshControlEnabled == YES) {
		self.refreshControl = [[UIRefreshControl alloc] init];
		//INFO: setting up refreshControl
		[self.refreshControl addTarget:self action:@selector(refreshControlRequest)
					  forControlEvents:UIControlEventValueChanged];
		
		//[RefreshControl setTintColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.630 alpha:1.000]];
		[self.tableView addSubview:self.refreshControl];
		
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 //	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
 
 }
 */
/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (void)refreshControlRequest {
	NSLog(@"%s | refresh table view", __PRETTY_FUNCTION__);
	
	//INFO: end
	[self.refreshControl endRefreshing];
}

@end
