//
//  StickerSelectionCollectionView.m
//  LMS
//
//  Created by Adrien Guffens on 10/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerSelectionCollectionView.h"

#define kDefaultShadowColor [UIColor darkGrayColor]
#define kDefaultShadowOffset CGSizeMake(0.0, 0.0)
#define kDefaultShadowOpacity 0.45//0.35

@implementation StickerSelectionCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self configure];
	//WARNING: could be bad
	self.stickerList = [[NSMutableArray alloc] init];
}

- (void)configure {
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

- (void)configureWithStickerList:(NSArray *)stickerList {
	//self.stickerList = stickerList;
	
	//self
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
