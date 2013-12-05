//
//  StickersViewController.m
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "StickersViewController.h"
#import "UIViewController+Extension.h"
#import "LMSStickerConfiguration.h"

#import "User+Manager.h"
#import "User.h"

//#import "LMSSticker+Manager.h"
#import "LMSSticker.h"

#import "Stickers+Manager.h"
#import "Stickers.h"

#import "StickerCell.h"

#import "NSDate+helpers.h"

#import "HeaderScanView.h"
#import "StickerDetailViewController.h"

static double kDefaultCellHeight = 80;

static NSString *stickerCellIdentifier = @"StickerCell";

@interface StickersViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Stickers *stickers;
@property (nonatomic, strong) NSMutableArray *stickerList;

@property (nonatomic, strong) ZBarReaderViewController *readerViewController;

@end

@implementation StickersViewController

#pragma mark - Configure

- (void)configure {
	[super configure];
	
	[self configureView];
	[self registerNibs];
	[self setupData];
	[self setupView];
}

#pragma mark - Base logic

- (void)configureView {
	[super configureView];
	
	[self configureMenuLeftButtonWithBackButon:[self.navigationController.viewControllers count] > 1];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.allowsSelection = YES;
}

- (void)registerNibs {
	[super registerNibs];
}

- (void)setupData {
	[super setupData];
	
	
	self.stickers = [[Stickers alloc] init];
	
	if (self.user == nil) {
		self.user = [[User alloc] init];
#warning TO IMPLEMENT
		//TODO: get the default id from the session manager
		self.user.id = 1;
	}
	
	
	[self.user update:^(id object) {
		if (object) {
			self.user = (User *)object;
			DLog(@"user: %@", self.user);
			
			self.stickers = [[Stickers alloc] init];
			[self.stickers updateWithUser:self.user andBlock:^(id object) {
				DLog(@"object: %@", object);
				if (object) {
					Stickers *stickers = (Stickers *)object;
					DLog(@"stickers.stickers: %@", stickers.stickers);
					self.stickerList = [[NSMutableArray alloc] initWithArray:stickers.stickers];
					
					[self.tableView reloadData];
//					[self.mapView loadStickerList:self.stickerList];
					
					//WARNING: bad -> reload only the targeted cell
					//					[self.tableView reloadData];
				}
			}];
		}
	}];

}

- (void)setupView {
	[super setupView];
	
}

#pragma mark - View controller life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	//    cell.backgroundColor = [UIColor clearColor];
	//	cell.selectedBackgroundView = nil;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
	//return [self.stickerList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	return [self.stickerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    StickerCell *cell = [tableView dequeueReusableCellWithIdentifier:stickerCellIdentifier];
    
    if (cell == nil) {
        cell = [[StickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stickerCellIdentifier];
    }
	[self configureCell:cell atIndexPath:indexPath];
//	NSArray *currentMenuList = [self.menuList objectAtIndex:indexPath.section];
//	MenuItem *menuItem = [currentMenuList objectAtIndex:indexPath.row];
//	/
//	cell.menuImageView.image = [UIImage imageNamed:menuItem.imageName ? menuItem.imageName : @"lms-300.png"];
//	cell.menuLabel.text = [menuItem.controller capitalizedString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LMSSticker *sticker = [self.stickerList objectAtIndex:indexPath.row];

	DLog(@"Selected sticker: %@", sticker);
//	[self performSegueWithIdentifier:@"stickerDetail" sender:self];
	StickerDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StickerDetailsController"];
	vc.sticker = sticker;
	[self.navigationController pushViewController:vc animated:YES];
}


- (void)configureCell:(StickerCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	LMSSticker *stickerRecord = [self.stickerList objectAtIndex:indexPath.row];
	
	cell.nameLabel.text = stickerRecord.name;
	
	NSString *timeString = [stickerRecord.createdAt distanceOfTimeInWords];//[ConventionTools getDiffTimeInStringFromDate:stickerRecord.createdAt];
	NSLog(@"%s - <%@", __PRETTY_FUNCTION__, timeString);
	timeString = [timeString length] > 0 ? timeString : @"new";
	cell.timeLabel.text = timeString;
	/*
	if ([stickerRecord.stickerConfiguration.activate)
		cell.activatedImage.backgroundColor = [UIColor greenColor];
	else
		cell.activatedImage.backgroundColor = [UIColor redColor];
	*/
	/*
	cell.iconLabel.font = [UIFont iconicFontOfSize:24];
	if (stickerRecord.stickerTypeId > StickerTypeSticker) {
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconPhone];
	}
	else
		cell.iconLabel.text = [NSString stringFromAwesomeIcon:FAIconQrcode];
	*/
	
	cell.iconLabel.hidden = YES;
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, stickerRecord.color);
	
	cell.colorView.backgroundColor = [UIColor colorFromHexString:stickerRecord.color];
	
	/*
	[cell setDelegate:self];
	[cell setFirstStateIconName:@"mathematic-multiply2-icon-white"
                     firstColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]//[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
            secondStateIconName:@"editing-delete-icon-white"
                    secondColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
                  thirdIconName:@"lms-icon-white"
                     thirdColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]//[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                 fourthIconName:@"very-basic-globe-icon-white"
                    fourthColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]
				   fithIconName:@"very-basic-refresh-icon-white"
					  fithColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];//[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]];
	
	
	*/
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState {
	NSLog(@"%s - %d", __PRETTY_FUNCTION__, buttonState);
	
//	self.currentIndexPath = [self.tableView indexPathForCell:cell];
	
//	NSLog(@"%s - %@", __PRETTY_FUNCTION__, self.currentIndexPath);
	
	switch (buttonState) {
		case MCSwipeTableViewButtonState1:
			break;
		case MCSwipeTableViewButtonState2://INFO: delete sticker
		{
//			[self deleteRowAtIndexPath:self.currentIndexPath forStickerCell:cell];
		}
			break;
		case MCSwipeTableViewButtonState3://INFO: sticker detail
		{
			[cell bounceToOrigin];
			[self performSegueWithIdentifier:@"stickerDetail" sender:self];
		}
			break;
		case MCSwipeTableViewButtonState4://INFO: map
		{
			[cell bounceToOrigin];
			//[self performSegueWithIdentifier:@"mapDetail" sender:self];
			
		}
			break;
		case MCSwipeTableViewButtonState5://INFO: share with friends
		{
			[cell bounceToOrigin];
			//[self performSegueWithIdentifier:@"FriendsSegue" sender:self];
			
		}
			break;
			
		default:
			break;
	}
}

- (void)swipeStickerTableViewCell:(StickerCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
	NSLog(@"%s - %d - %d", __PRETTY_FUNCTION__, state, mode);
	
}


- (IBAction)scanHandler:(id)sender {
	NSLog(@"Scanning..");
//    resultTextView.text = @"Scanning..";
	
    self.readerViewController = [[ZBarReaderViewController alloc] init];
    self.readerViewController.readerDelegate = self;
    self.readerViewController.supportedOrientationsMask = ZBarOrientationMaskAll;
	
    ZBarImageScanner *scanner = self.readerViewController.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];

	UIView *mainView = [self.readerViewController.view.subviews objectAtIndex:0];
	mainView.frame = self.readerViewController.view.bounds;
	
	UIView *tabBar = [self.readerViewController.view.subviews objectAtIndex:1];
	tabBar.hidden = YES;
//	tabBar.tintColor = [UIColor whiteColor];
//	tabBar.backgroundColor = [UIColor whiteColor];
	
	for (UIView *view in self.readerViewController.view.subviews) {
		DLog(@"view: %@", [view description]);
	}
	
//	readerViewController.showsCameraControls = NO;  // for UIImagePickerController
	self.readerViewController.showsZBarControls = YES;
	self.readerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;

	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainView.bounds.size.width, 50)];
	view.backgroundColor = [UIColor whiteColor];
	view.layer.opacity = 0.6;

	HeaderScanView *containerView = [[HeaderScanView alloc] initWithFrame:CGRectMake(0, mainView.bounds.size.height - 50, view.bounds.size.width, 50)];
	containerView.opaque = NO;
	containerView.backHandler = ^(id object) {
		//[self.readerViewController removeFromParentViewController];//dismissViewControllerAnimated:YES completion:^{
//			DLog(@"Scan dismiss");
//		}];
		DLog(@"BAck or die");
	};
//	containerView.backgroundColor = [UIColor redColor];
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 50)];//CGRectMake(0, mainView.bounds.size.height - 50, mainView.bounds.size.width, 50)];
	[button setTitle:@"Back" forState:UIControlStateNormal];
	[button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[button addTarget:self action:@selector(backHandler:) forControlEvents:UIControlEventTouchDown];
	
	[containerView addSubview:view];
	[containerView addSubview:button];
	
	self.readerViewController.cameraOverlayView = containerView;
	
    [self presentViewController:self.readerViewController animated:YES completion:nil];

}

- (void)backHandler:(id)sender {
	DLog(@"Back");
	[self.readerViewController dismissViewControllerAnimated:YES completion:^{
		DLog(@"Scan dismiss");
	}];
}

- (void)imagePickerController:(UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
	
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
	
    // showing the result on textview
//    resultTextView.text = symbol.data;
	DLog(@"%@", symbol.data);
	
//    resultImageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
	
    // dismiss the controller
    [reader dismissViewControllerAnimated:YES completion:nil];
}

@end
