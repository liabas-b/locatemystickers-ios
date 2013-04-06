//
//  ImageViewController.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "UCImage.h"

#import "DebugTools.h"
#import "FileTools.h"
#import "ApplicationTools.h"
#import "CryptographyTools.h"

@interface UCImage ()

- (void)initIndicator;
- (void)initScroolView:(CGRect)frame;
- (void)initDirectory;

- (void)imageDidFinishLoading:(UIImage *)image;

- (NSString *)pathFromFileName:(NSString *)fileName;

@end

@implementation UCImage

@synthesize Indicator = _indicator;
@synthesize Directory = _directory; /* INFO: = image */

#pragma mark -
#pragma mark Init

- (id)initWithFrame:(CGRect)frame andEnabledZoom:(BOOL)zoomEnable {
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self->_imageView = [[UIImageView alloc] init];
		self->_imageView.frame = self.bounds;
		self->_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self->_directory= @"image";
		
		[self initIndicator];
		
		UIView *container = self;
		
		if (zoomEnable) {
			[self initScroolView:frame];			
			container = self->_scroll;
		}
		
		[container addSubview:self->_indicator];
		[container addSubview:self->_imageView];
		
		[self initDirectory];
    }
    return self;
}

- (void)initIndicator {
	self->_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
						UIActivityIndicatorViewStyleGray];
	// Set mask
	self->_indicator.autoresizingMask =
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | 
	UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
	
	// Set on center
	self->_indicator.center = CGPointMake(0, 0);
	self->_indicator.frame = self.frame;
}

- (void)initScroolView:(CGRect)frame {
	self->_scroll = [[UIScrollView alloc] initWithFrame:frame];
	//config scroll view
	self->_scroll.delegate = self;
	self->_scroll.minimumZoomScale = 1;
	self->_scroll.maximumZoomScale = 4;
	self->_scroll.scrollEnabled = YES;
	self->_scroll.multipleTouchEnabled = YES;
	self->_scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:self->_scroll];
}

- (void)initDirectory {
	[FileTools createDirectory:self->_directory atFilePath:[ApplicationTools getApplicationDirectory]];
}

#pragma mark -
#pragma mark Scroll View

- (UIView *)viewForZoomingInScrollView : (UIScrollView *)scrollView
{
	[DebugTools addDebug:self
			 withMethode:@"- (UIView *) viewForZoomingInScrollView : (UIScrollView *)scrollView" 
				 andType:information
			   andDetail:@""];
	return self->_imageView;
}

#pragma mark -
#pragma mark Image

- (void)loadImageWithUrl:(NSString *)url {
	NSURL *urlFinal = [[NSURL alloc] initWithString:url];
	NSData *dataImage;
	
	NSString *fileName = [CryptographyTools stringToMD5:url];

	if (![FileTools fileExist:[self pathFromFileName:fileName]]) {
		dataImage = [[NSData alloc] initWithContentsOfURL:urlFinal];
		[DebugTools addDebug:self
				 withMethode:@"- (void)startLoadingImageWithUrl:(NSString *)url"
					 andType:information
				   andDetail:[NSString stringWithFormat:@"%@", fileName]];
		[dataImage writeToFile:[self pathFromFileName:fileName] atomically:YES];
	}
	else {
		dataImage = [[NSData alloc] initWithContentsOfFile:[self pathFromFileName:fileName]];
	}
	
	UIImage *img = [[UIImage alloc] initWithData:dataImage];
	
	[self performSelectorOnMainThread:@selector(imageDidFinishLoading:)
						   withObject:img waitUntilDone:YES];	
}

- (void)loadImageWithFile:(NSString *)file {		
	[DebugTools addDebug:self
			 withMethode:@"- (void)loadImageWithFile:(NSString *)file" andType:information 
			   andDetail:[self pathFromFileName:file]];
	NSData *dataImage;
	
	dataImage = [[NSData alloc] initWithContentsOfFile:[self pathFromFileName:file]];
	
	UIImage *img = [[UIImage alloc] initWithData:dataImage];
	
	[self performSelectorOnMainThread:@selector(imageDidFinishLoading:)
						   withObject:img waitUntilDone:YES];	
}

- (void)imageDidFinishLoading:(UIImage *)image {
	[DebugTools addDebug:self
			 withMethode:@"- (void)imageDidFinishLoading:(UIImage*)image"
				 andType:information
			   andDetail:@""];

	[self->_imageView setImage:image];
	[self->_indicator stopAnimating];
}

- (void)loadWithUrl:(NSString *)urlImage {
	[DebugTools addDebug:self
			 withMethode:@"- (void)loadWithUrl:(NSString *)urlImage"
				 andType:information
			   andDetail:urlImage];
	[self->_indicator startAnimating];
	if (urlImage)
		[self performSelectorInBackground:@selector(loadImageWithUrl:)
							   withObject:urlImage];
}

- (void)loadWithFile:(NSString *)fileImage {
	[DebugTools addDebug:self
			 withMethode:@"- (void)loadWithId:(NSString *)idImage"
				 andType:information
			   andDetail:fileImage];
	[self->_indicator startAnimating];
	if (fileImage)
		[self performSelectorInBackground:@selector(loadImageWithFile:)
							   withObject:fileImage];
}

#pragma mark -
#pragma mark Misc

- (NSString *)pathFromFileName:(NSString *)fileName {
	NSString *pathFromFile = [NSString stringWithFormat:@"%@/%@/%@",
							  [ApplicationTools getApplicationDirectory],
							  self->_directory,
							  fileName];
	[DebugTools addDebug:self
			 withMethode:@"- (NSString *)pathFromFileName:(NSString *)fileName" andType:information
			   andDetail:pathFromFile];
	return pathFromFile;
}

- (void)setDirectory:(NSString *)Directory {
	self->_directory = Directory;
	[self initDirectory];
}

@end
