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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - view

- (void)updateView {
	
	if (self.stickerRecord) {
		if (self.stickerRecord.isActive)
			self.activatedImage.backgroundColor = [UIColor greenColor];
		else
			self.activatedImage.backgroundColor = [UIColor redColor];
		self.nameLabel.text = self.stickerRecord.name;
		self.createdAtLabel.text = [ConventionTools getDiffTimeInStringFromDate:self.stickerRecord.createdAt];//[self.stickerRecord.createdAt description];
		self.updatedAtLabel.text = [ConventionTools getDiffTimeInStringFromDate:self.stickerRecord.updatedAt];//[self.stickerRecord.updatedAt description];
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

		self.stickerRecord = [StickerRecord addUpdateStickerWithDictionary:[dataDictionary objectForKey:@"data"]];
		if (self.stickerRecord != nil)
			[[NSManagedObjectContext defaultContext] saveNestedContexts];
		
		[self.stickerRecord debug];
		
		[self updateView];
		
	}
}

- (IBAction)handleDetailedMapButton:(id)sender {
}

@end
