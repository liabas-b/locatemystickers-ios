//
//  TopMenuView.m
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "TopMenuView.h"

@implementation TopMenuView

- (void)awakeFromNib {
	[super awakeFromNib];
	[self configure];
}

- (void)configure {
	//INFO: do some stuff if needed
	DLog(@"");
	self.appNameLabel.font = [UIFont defaultTitleFont];
	self.appNameLabel.textColor = [UIColor defaultTitleColor];
}


@end
