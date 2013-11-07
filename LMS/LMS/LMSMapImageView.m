//
//  LMSMapImageView.m
//  LMS
//
//  Created by Adrien Guffens on 03/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapImageView.h"

@implementation LMSMapImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self configureView];
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self configureView];
}

- (void)configureView {
	
	/*
	self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorFromHexString:@"#DFDFDF"].CGColor;
    */
	//    self.backgroundColor = [UIColor defaultColor];//[UIColor colorFromHexString:@"#F9F9F9"];
    
    //TODO: if device > iPhone 4 (at least)
    if (NO) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 1.0f;
    }
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
