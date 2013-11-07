//
//  LMSMapBaseView.m
//  LMS
//
//  Created by Adrien Guffens on 03/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapBaseView.h"

@implementation LMSMapBaseView

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
	
	UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.bounds.size.height)];
	lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
	[self addSubview:lineView];
//	self.layer.borderWidth = 1.0;
//    self.layer.borderColor = [UIColor colorFromHexString:@"#DFDFDF"].CGColor;
    
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
