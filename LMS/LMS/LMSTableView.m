//
//  LMSTableView.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSTableView.h"

@implementation LMSTableView

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

	if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
		[self setSeparatorInset:UIEdgeInsetsZero];
//		[self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
