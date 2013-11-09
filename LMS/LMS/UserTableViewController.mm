//
//  UserTableViewController.m
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "UserTableViewController.h"
#import "LMSSticker.h"
//#import "UCTabBarItem.h"
#import "AppDelegate.h"

#import "UIViewController+Extension.h"

//#import "UIColor+AppColor.h"
//#import "UIFont+AppFont.h"

void freeRawData(void *info, const void *data, size_t size);

@interface UserTableViewController ()

@end

@implementation UserTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad {
	self.refreshControlEnabled = NO;
    [super viewDidLoad];
	
	[self configureMenuLeftButtonWithBackButon:NO];
	
#warning Code is BADLY configured
	DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:@"UID"];
    UIImage *qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:182];
    
	self.qrCodeImageView.image = qrcodeImage;//[self quickResponseImageForString:[AppDelegate identifierForCurrentUser] withDimension:182];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSNumber *yourStickersNumber = @42;//[StickerRecord numberOfEntities];
	
	NSString *yourStickersString = [NSString stringWithFormat:@"Your stickers (%@)", yourStickersNumber];
	self.yourStickersLabel.text = yourStickersString;
	
#warning TO IMPLEMENT sharring stickers number
	NSPredicate *predicate = nil;
	int sharringStickersNumber = 2;//[StickerRecord numberOfEntitiesWithPredicate:predicate];
	
	NSString *sharringStickersString = [NSString stringWithFormat:@"Followed stickers (%d)", sharringStickersNumber];
	self.sharringStickersLabel.text = sharringStickersString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
	[super awakeFromNib];
	/*
	self.tabBarItem = [[UCTabBarItem alloc] initWithTitle:@"User"
											imageSelected:@"account_black"
											andUnselected:@"account_white"];
	 */
	self.yourStickersLabel.font = [UIFont defaultFont];
	self.sharringStickersLabel.font = [UIFont defaultFont];
	_historiesLabel.font = [UIFont defaultFont];
	_accountInfoLabel.font = [UIFont defaultFont];
	_logoutLabel.font = [UIFont defaultFont];
	_settingsLabel.font = [UIFont defaultFont];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundColor:[UIColor whiteColor]];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/*
void freeRawData(void *info, const void *data, size_t size) {
    free((unsigned char *)data);
}

- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth {
    
    QRcode *resultCode = QRcode_encodeString([dataString UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    
    unsigned char *pixels = (*resultCode).data;
    int width = (*resultCode).width;
    int len = width * width;
    
    if (imageWidth < width)
        imageWidth = width;
    
    // Set bit-fiddling variables
    int bytesPerPixel = 4;
    int bitsPerPixel = 8 * bytesPerPixel;
    int bytesPerLine = bytesPerPixel * imageWidth;
    int rawDataSize = bytesPerLine * imageWidth;
    
    int pixelPerDot = imageWidth / width;
    int offset = (int)((imageWidth - pixelPerDot * width) / 2);
    
    // Allocate raw image buffer
    unsigned char *rawData = (unsigned char*)malloc(rawDataSize);
    memset(rawData, 0xFF, rawDataSize);
    
    // Fill raw image buffer with image data from QR code matrix
    int i;
    for (i = 0; i < len; i++) {
        char intensity = (pixels[i] & 1) ? 0 : 0xFF;
        
        int y = i / width;
        int x = i - (y * width);
        
        int startX = pixelPerDot * x * bytesPerPixel + (bytesPerPixel * offset);
        int startY = pixelPerDot * y + offset;
        int endX = startX + pixelPerDot * bytesPerPixel;
        int endY = startY + pixelPerDot;
        
        int my;
        for (my = startY; my < endY; my++) {
            int mx;
            for (mx = startX; mx < endX; mx += bytesPerPixel) {
                rawData[bytesPerLine * my + mx    ] = intensity;    //red
                rawData[bytesPerLine * my + mx + 1] = intensity;    //green
                rawData[bytesPerLine * my + mx + 2] = intensity;    //blue
                rawData[bytesPerLine * my + mx + 3] = 255;          //alpha
            }
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, rawDataSize, (CGDataProviderReleaseDataCallback)&freeRawData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageWidth, imageWidth, 8, bitsPerPixel, bytesPerLine, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    UIImage *quickResponseImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    QRcode_free(resultCode);
    
    return quickResponseImage;
}
*/

@end
