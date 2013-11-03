//
//  LMSHeaderMapView.m
//  LMS
//
//  Created by Adrien Guffens on 02/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSHeaderMapView.h"
#import "UIImageView+AFNetworking.h"
#import <NSString+MD5.h>
#import "CryptographyTools.h"

#define kDefaultShadowColor [UIColor darkGrayColor]
#define kDefaultShadowOffset CGSizeMake(0.0, 0.0)
#define kDefaultShadowOpacity 0.45//0.35

@interface LMSHeaderMapView ()

@property (nonatomic, strong) NSString *email;

@end

@implementation LMSHeaderMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self configure];
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self configureView];
	
	[self configure];
}

- (void)configure {
	self.email = @"b.liabastre@gmail.com";
	
	self.backgroundColor = [UIColor colorFromHexString:@"#f1f1f1"];

	self.appName.font = [UIFont defaultTitleFont];
	self.notificationCountLabel.font = [UIFont defaultFont];
	
//	NSString *hashGravatar = [@"b.liabastre@gmail.com" MD5];
	NSString *hashGravatar = [CryptographyTools stringToMD5:self.email];
	NSString *gravatarUrl = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", hashGravatar];
	
	[self.profileImageView setImageWithURL:[NSURL URLWithString:gravatarUrl] placeholderImage:[UIImage imageNamed:@"locateMyStickersFushiaSmallLogo"]];
	
	[self.stickerMapViewButton setButtonImage:[UIImage imageNamed:@"pin.png"] withButtonValue:@"Stickers"];
	[self.friendMapViewButton setButtonImage:[UIImage imageNamed:@"friend.png"] withButtonValue:@"Friends"];
}

- (void)configureView {
	
	UITapGestureRecognizer *stickerSingleFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(handleStickerSingleTap:)];
	[self.stickerMapViewButton addGestureRecognizer:stickerSingleFingerTap];

	
	UITapGestureRecognizer *friendSingleFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(handleFriendSingleTap:)];
	[self.friendMapViewButton addGestureRecognizer:friendSingleFingerTap];

	self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorFromHexString:@"#DFDFDF"].CGColor;
    
    self.backgroundColor = [UIColor colorFromHexString:@"#F9F9F9"];
    
    //TODO: if device > iPhone 4 (at least)
    if (YES) {
		self.layer.frame = CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height);
        self.layer.shadowColor = kDefaultShadowColor.CGColor;
        self.layer.shadowOffset = kDefaultShadowOffset;
        self.layer.shadowOpacity = kDefaultShadowOpacity;
        self.layer.shadowRadius = 5;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
		/*
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 1.0f;
		 */
    }
}

- (void)handleStickerSingleTap:(UITapGestureRecognizer *)recognizer {
	CGPoint location = [recognizer locationInView:[recognizer.view superview]];

	[self.delegate didToggleStickerButton:self.stickerMapViewButton];
}

- (void)handleFriendSingleTap:(UITapGestureRecognizer *)recognizer {
	CGPoint location = [recognizer locationInView:[recognizer.view superview]];
	
	[self.delegate didToggleFriendButton:self.friendMapViewButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
