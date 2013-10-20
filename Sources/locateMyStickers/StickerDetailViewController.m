//
//  StickerDetailViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/1/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerDetailViewController.h"
#import "StickerRecord.h"
#import "StickerRecord+Manager.h"

#import "AFJSONRequestOperation.h"

#import "LocationRecord+Manager.h"

#import "ConventionTools.h"
#import "JsonTools.h"
#import "AppDelegate.h"

#import "UIFont+AppFont.h"
#import "UIColor+AppColor.h"
#import "UIViewController+Extension.h"
#import "StickerConfigurationRecord.h"

#import "StickerEditingViewController.h"

static double kHeightWithoutLabel = 55.0;
static double kHeightLastLocationWithoutLabel = 25.0;

@interface StickerDetailViewController ()

@property(nonatomic, assign) CGRect mapRect;

@end

@implementation StickerDetailViewController

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
	self.refreshControlEnabled = YES;
    [super viewDidLoad];
	
	self.mapView.mapViewDelegate = self;
	self.mapView.isDisplayingStickerList = NO;
	
	[self setupView];
	[self updateView];
	
	[self updateSticker];
	[self updateLocationRecords];
	
	UITapGestureRecognizer *mapSingleFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(mapSingleTapHandler:)];
	[self.mapView addGestureRecognizer:mapSingleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//DEBUG: test
//	[self performSelectorInBackground:@selector(setupMap) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heightForRow;
    
    switch (indexPath.row) {
		case 0:
			
		{
			heightForRow = 42.0;
		}
			break;
		case 1:
			
		{
			heightForRow = 195.0;
		}
			break;
		case 2:
			
		{
			heightForRow = 42.0;
		}
			break;
		case 3:
			
		{
			NSString *text = [self.stickerRecord.lastLocation stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
            CGSize labelSize = [text sizeWithFont:[UIFont defaultFont] constrainedToSize:CGSizeMake(160, 20000) lineBreakMode:NSLineBreakByWordWrapping];//180
			NSLog(@"%s | self.stickerRecord.lastLocation: %@", __PRETTY_FUNCTION__, self.stickerRecord.lastLocation);
			NSLog(@"%s | text: %@", __PRETTY_FUNCTION__, text);
			if (labelSize.height == 0)
				heightForRow = 0;
			else
				heightForRow = kHeightLastLocationWithoutLabel + labelSize.height;//42 + 10
		}
			break;
        case 4:
        {
			NSString *text = _stickerRecord.text;
            CGSize labelSize = [text sizeWithFont:[UIFont defaultFont] constrainedToSize:CGSizeMake(240, 20000) lineBreakMode:NSLineBreakByWordWrapping];
            heightForRow = kHeightWithoutLabel + labelSize.height;//42 + 10
        }
            break;
            
        default:
        {
			heightForRow = 82.0;
			
        }
            break;
    }
    return heightForRow;
}

//

- (void)zoomOnMapView {
	// Get main window reference
	UIWindow* mainWindow = (((AppDelegate *)[UIApplication sharedApplication].delegate).window);
	
	CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	self.mapRect = self.mapView.frame;
	[mainWindow addSubview:self.mapView];
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
						 //INFO: set in full screen
						 self.mapView.frame = rect;
						 
                     }
                     completion:^(BOOL finished1) {
						 [self.mapView addCloseButton];
					 }];
	
}

#pragma mark - view

- (void)setupView {
	//TODO: Last update date
	[self configureMenuLeftButtonWithBackButon:YES];
	
	self.nameLabel.font = [UIFont defaultFont];
	self.nameLabel.textColor = [UIColor defaultFontColor];
	
	self.textLabel.font = [UIFont defaultFont];
	self.textLabel.textColor = [UIColor defaultFontColor];
	
	self.createdAtLabel.font = [UIFont defaultFont];
	self.createdAtLabel.textColor = [UIColor defaultFontColor];
	
	self.updatedAtLabel.font = [UIFont defaultFont];
	self.updatedAtLabel.textColor = [UIColor defaultFontColor];
	
	self.colorView.backgroundColor = [UIColor colorFromHexString:_stickerRecord.color];
}

- (void)updateView {
	self.enableSwitch.on = NO;
	self.enableSwitch.hidden = YES;
	if (self.stickerRecord) {
		
		if ([self.stickerRecord.stickerConfiguration.activate boolValue])
			self.activatedImage.backgroundColor = [UIColor greenColor];
		else
			self.activatedImage.backgroundColor = [UIColor redColor];
		
		self.nameLabel.text = self.stickerRecord.name;
		
		self.createdAtLabel.text = [ConventionTools getDiffTimeInStringFromDate:self.stickerRecord.createdAt];
		
		NSString *lastLocation = [self.stickerRecord.lastLocation stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
		self.updatedAtLabel.text = lastLocation;
		
		self.textLabel.text = self.stickerRecord.text;
		
		[self.mapView loadSticker:self.stickerRecord];
		
	}
}

#pragma mark - data parsing

- (void)updateSticker {
	
	[[AppDelegate appDelegate].stickerManager updateStickerRecordWithStickerRedord:self.stickerRecord success:^(NSMutableDictionary *JSON) {
		NSLog(@"%s| JSON: %@", __PRETTY_FUNCTION__, JSON);
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:JSON];
		if (stickerRecord) {
			self.stickerRecord = stickerRecord;
			NSLog(@" %s| stickerRecord: %@", __PRETTY_FUNCTION__, stickerRecord);
			[self updateView];
			[self.refreshControl endRefreshing];
		}
		
	} failure:^(NSURLRequest *request, NSError *error) {
		[self.refreshControl endRefreshing];
	}];
}

- (void)updateLocationRecords {
	[[AppDelegate appDelegate].locationManager updateLocationRecordsForSticker:self.stickerRecord success:^(NSMutableDictionary *JSON) {
		[self.refreshControl endRefreshing];
		
		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			LocationRecord *locationRecord = [LocationRecord addUpdateWithDictionary:dic];
			NSLog(@" %s| locationRecord: %@", __PRETTY_FUNCTION__, locationRecord);
		}
		if ([JSON count] > 0) {
			[self.mapView loadSticker:self.stickerRecord];
		}

	} failure:^(NSURLRequest *request, NSError *error, id JSON) {
		[self.refreshControl endRefreshing];
	}];
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"textViewShouldBeginEditing:");
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor greenColor];
}

#pragma mark - Map Handler

- (void)mapSingleTapHandler:(UITapGestureRecognizer *)recognizer {
	[self zoomOnMapView];
}

- (IBAction)closeMapHandler:(id)sender {
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
						 
						 
                     }
                     completion:^(BOOL finished1) {
						 self.mapView.frame = self.mapRect;
						 
						 [self.mapView removeFromSuperview];
						 [self.mapCell.contentView addSubview:self.mapView];
						 
					 }];
	
}

#pragma mark - LMSMapViewProtocol

- (void)closeMapButtonHandler {
	[self closeMapHandler:nil];
}

- (void)refreshControlRequest {
	

	
	[self updateSticker];
	[self updateLocationRecords];
}

//EditStickerConfigurationSegue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"EditStickerConfigurationSegue"]) {
		StickerEditingViewController *stickerEditingViewController = [segue destinationViewController];
		stickerEditingViewController.stickerConfigurationRecord = self.stickerRecord.stickerConfiguration;
	}
}

@end
