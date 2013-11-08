//
//  FollowedStickersViewController.m
//  LMS
//
//  Created by Adrien Guffens on 9/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "FollowedStickersViewController.h"
#import "LMSSticker+Manager.h"

#import "NSString+FontAwesome.h"
//#import "UIFont+FontAwesome.h"

#import "FollowedStickerCell.h"
#import "StickerDetailViewController.h"

//#import "ConventionTools.h"
//#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"

#import "UIViewController+Extension.h"

#import "UIColor+Colours.h"

#import "LMSStickerConfiguration.h"

#import "NSDate+AppDate.h"

@interface FollowedStickersViewController ()

@property (nonatomic, strong)NSMutableArray *followedStickersList;
@property (nonatomic, strong)LMSSticker *currentSticker;

@end

@implementation FollowedStickersViewController

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
	
	[self configureMenuLeftButtonWithBackButon:[self.navigationController.viewControllers count] > 1];

	
	self.followedStickersList = [[NSMutableArray alloc] init];
	[self updateFollowedStickers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Web Service Histories request

- (void)updateFollowedStickers {
	/*
	NSString *route = @"followed_stickers";
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"Result: %@", JSON);
		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dic];
			NSLog(@" %s| stickerRecord: %@", __PRETTY_FUNCTION__, stickerRecord);
			if (![self.followedStickersList containsObject:stickerRecord]) {
				[self.followedStickersList addObject:stickerRecord];
				[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.followedStickersList count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
			}
		}
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	[operation start];
	 */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.followedStickersList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FollowedStickerCell";
    FollowedStickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	LMSSticker *sticker = [self.followedStickersList objectAtIndex:indexPath.row];
	self.currentSticker = sticker;

	cell.nameLabel.text = sticker.name;
	/*
	NSString *timeString = [sticker.createdAt distanceOfTimeInWords];//[ConventionTools getDiffTimeInStringFromDate:stickerRecord.createdAt];
	timeString = [timeString length] > 0 ? timeString : @"new";
	cell.timeLabel.text = timeString;
	
	if ([stickerRecord.stickerConfiguration.activate boolValue])
		cell.activatedImage.backgroundColor = [UIColor greenColor];
	else
		cell.activatedImage.backgroundColor = [UIColor redColor];
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
	backgroundView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
	
	cell.backgroundView = backgroundView;
	
	cell.iconLabel.font = [UIFont iconicFontOfSize:24];
	if ([stickerRecord.stickerTypeId intValue] > StickerTypeSticker) {
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconPhone];
	}
	else
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconQrcode];
	
	cell.colorView.backgroundColor = [UIColor colorFromHexString:stickerRecord.color];
    */
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self performSegueWithIdentifier:@"StickerDetailSegue" sender:self];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"StickerDetailSegue"]) {
		StickerDetailViewController *stickerDetailViewController = (StickerDetailViewController *)[segue destinationViewController];
		[stickerDetailViewController setSticker:self.currentSticker];
	}
}

@end
