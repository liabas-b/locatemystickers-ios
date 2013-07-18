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
	
	[self updateView];
	[self parseData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self performSelectorInBackground:@selector(setupMap) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
		self.createdAtLabel.text = [ConventionTools getDiffTimeInStringFromDate:self.stickerRecord.createdAt];//[self.stickerRecord.createdAt description];
		self.updatedAtLabel.text = @"Unknow";//[ConventionTools getDiffTimeInStringFromDate:self.stickerRecord.updatedAt];//[self.stickerRecord.updatedAt description];
		self.descriptionTextView.text = self.stickerRecord.text;
	}
}

#pragma mark - data parsing

- (void)parseData
{
	NSString *hostName = [AppDelegate appDelegate].sessionManager.session.hostName;
	NSString *requestString = [NSString stringWithFormat:@"%@/users/3/stickers/%@.json", hostName, self.stickerRecord.stickerId];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	
	NSLog(@"[StickerDetailViewController] requestString: %@", requestString);
	
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
		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		StickerRecord *stickerRecord = [StickerRecord addUpdateStickerWithDictionary:dataDictionary];
		if (stickerRecord != nil) {
			
			self.stickerRecord = stickerRecord;
			
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
			
			[self.stickerRecord debug];
			[self updateView];
		}
	}
}

- (void)setupMap {
	NSArray *array = [LocationRecord findByAttribute:@"idSticker" withValue:self.stickerRecord.stickerId andOrderBy:@"updatedAt" ascending:NO];//findAllSortedBy:@"idLocation" ascending:YES];
	NSLog(@"%s %@", __PRETTY_FUNCTION__, array);
	if ([array count] > 0) {
		self.mapView.locationsRecordList = [[NSMutableArray alloc] initWithArray:array];
		
		//	[self.mapView loadSelectedOptions];
		[self.mapView performSelectorOnMainThread:@selector(loadSelectedOptions) withObject:nil waitUntilDone:YES];
	}
	else {
		[self updateLocationForSticker];
	}
}

- (void)updateLocationForSticker {
	
	NSString *route = [NSString stringWithFormat:@"stickers/%@/locations", self.stickerRecord.stickerId];
	NSURLRequest *request = [AppDelegate requestForCurrentUserWithRoute:route];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSLog(@"Result: %@", JSON);
		for (NSDictionary *dic in [JSON objectForKey:@"data"]) {
			NSLog(@" %s| dic: %@", __PRETTY_FUNCTION__, dic);
			LocationRecord *locationRecord = [LocationRecord addUpdatelocationWithDictionary:dic];
			NSLog(@" %s| locationRecord: %@", __PRETTY_FUNCTION__, locationRecord);
		}
		if ([[JSON objectForKey:@"data"] count] > 0)
			[self setupMap];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
	}];
	[operation start];
}

/*
//INFO: test

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
*/

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"textViewShouldBeginEditing:");
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor greenColor];
}

@end
