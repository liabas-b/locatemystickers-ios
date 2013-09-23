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
    [super viewDidLoad];
	
	self.mapView.mapViewDelegate = self;
	
	[self updateView];

	[self updateSticker];
	[self updateLocationForSticker];
	
	UITapGestureRecognizer *mapSingleFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(mapSingleTapHandler:)];
	[self.mapView addGestureRecognizer:mapSingleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//DEBUG: test
	[self performSelectorInBackground:@selector(setupMap) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)t {
	// Get main window reference
	UIWindow* mainWindow = (((AppDelegate *)[UIApplication sharedApplication].delegate).window);
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
						 CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
						 //INFO: sav
						 self.mapRect = self.mapView.frame;
						 //INFO: set in full screen
						 self.mapView.frame = rect;
						 [mainWindow addSubview:self.mapView];

                     }
                     completion:^(BOOL finished1) {
						 
					 }];

}

#pragma mark - view

- (void)updateView {
	self.enableSwitch.on = NO;
	self.enableSwitch.hidden = YES;
	if (self.stickerRecord) {
		if (self.stickerRecord.isActive)
			self.activatedImage.backgroundColor = [UIColor greenColor];
		else
			self.activatedImage.backgroundColor = [UIColor redColor];
		self.nameLabel.text = self.stickerRecord.name;
		self.createdAtLabel.text = [ConventionTools getDiffTimeInStringFromDate:self.stickerRecord.createdAt];
		self.updatedAtLabel.text = @"Unknow";
		self.descriptionTextView.text = self.stickerRecord.text;
		
	}
}

#pragma mark - data parsing

- (void)updateSticker {
	
	NSString *requestString = [NSString stringWithFormat:@"stickers/%@", self.stickerRecord.stickerId];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:requestString];
	
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"Result: %@", JSON);
		
		NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, JSON);
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:JSON];
		if (stickerRecord) {
			self.stickerRecord = stickerRecord;
			
//			[[NSManagedObjectContext defaultContext] saveNestedContexts];
			NSLog(@" %s| stickerRecord: %@", __PRETTY_FUNCTION__, stickerRecord);
			[self.stickerRecord debug];
			[self updateView];
		}
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[operation start];
}

- (void)setupMap {
	NSArray *array = [LocationRecord findByAttribute:@"idSticker" withValue:self.stickerRecord.stickerId andOrderBy:@"updatedAt" ascending:NO];//findAllSortedBy:@"idLocation" ascending:YES];
	NSLog(@"%s %@", __PRETTY_FUNCTION__, array);
	if ([array count] > 0) {
		[self.mapView.locationsRecordList addObjectsFromArray:array];// = [[NSMutableArray alloc] initWithArray:array];
		
		[self.mapView performSelectorOnMainThread:@selector(loadSelectedOptions) withObject:nil waitUntilDone:YES];
	}
	else {
		[self updateLocationForSticker];
	}
}

- (void)updateLocationForSticker {
	
	NSString *route = [NSString stringWithFormat:@"stickers/%@/locations", self.stickerRecord.code];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	NSLog(@"%s | request: %@", __PRETTY_FUNCTION__, [request description]);
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"Result: %@", JSON);
		for (NSDictionary *dic in JSON) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			LocationRecord *locationRecord = [LocationRecord addUpdateWithDictionary:dic];
			NSLog(@" %s| locationRecord: %@", __PRETTY_FUNCTION__, locationRecord);
		}
		if ([JSON count] > 0)
			[self setupMap];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	[operation start];
	
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
	[self t];
}

- (IBAction)closeMapHandler:(id)sender {
//	UIWindow* mainWindow = (((AppDelegate *)[UIApplication sharedApplication].delegate).window);
	
	[UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^{
//						 [mainWindow //addSubview:self.mapView];
						 
						 
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
@end
