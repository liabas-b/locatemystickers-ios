//
//  StickerDetailViewController.m
//  LMS
//
//  Created by Adrien Guffens on 3/1/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerDetailViewController.h"
#import "StickerRecord.h"

#import "JsonTools.h"

@interface StickerDetailViewController ()

@property(nonatomic, strong)StickerRecord *stickerRecord;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self parseData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - view

- (void)updateView {
	
	if (self.stickerRecord.isActive)
		self.activatedImage.backgroundColor = [UIColor greenColor];
	else
		self.activatedImage.backgroundColor = [UIColor redColor];
	self.nameLabel.text = self.stickerRecord.name;
	self.createdAtLabel.text = self.stickerRecord.createdAt;
	self.updatedAtLabel.text = self.stickerRecord.updatedAt;
	
}


#pragma mark - data parsing

- (void)parseData
{
	
    // TODO: Create an Operation Queue [OK]
	
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://web-service.locatemystickers.com/users/1/stickers/460.json"]];
	[request setHTTPMethod:@"GET"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self didReceiveData:data];
	}];
}

- (void)didReceiveData:(NSData *)data {
	//INFO: debug
	/*
	 if (data) {
	 NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	 NSLog(@"------ <%@>", dataString);
	 }
	 else
	 NSLog(@"BAD");
	 */
	
	if (data) {
		//TODO: save file

		
		NSDictionary *dataDictionary = [JsonTools getDictionaryFromData:data];
		
		
		self.stickerRecord = [[StickerRecord alloc] initWithDictinary:[dataDictionary objectForKey:@"data"]];
		[self.stickerRecord debug];
		
		[self updateView];
		
	}
}

- (IBAction)handleDetailedMapButton:(id)sender {
}
@end
