//
//  ImageViewController.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCImage : UIView <UIScrollViewDelegate > {
	UIScrollView *_scroll;
	UIImageView *_imageView;
	UIActivityIndicatorView *_indicator;
	NSString *_directory;
}

@property(nonatomic, strong) UIActivityIndicatorView *Indicator;
@property(nonatomic, strong)NSString *Directory;

- (id)initWithFrame:(CGRect)frame andEnabledZoom:(BOOL)zoomEnable;

- (void)loadWithUrl:(NSString *)urlImage;
- (void)loadWithFile:(NSString *)fileImage;

- (NSString *)pathFromFileName:(NSString *)fileName;

@end
