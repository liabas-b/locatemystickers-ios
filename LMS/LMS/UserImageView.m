//
//  UserImageView.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UserImageView.h"
#import <UIImage+FlatUI.h>

@implementation UserImageView

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
	
	[self styleWithColor:[UIColor applicationColor]];
}

- (void)styleWithColor:(UIColor *)color {
		
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 4.0f;
    self.layer.borderColor = color.CGColor;
	self.layer.cornerRadius = roundf(self.frame.size.width / 2.0);
}

@end
