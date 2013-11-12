//
//  UserToolView.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UserToolView.h"

@implementation UserToolView

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
}

- (void)configure {
	self.nameLabel.font = [UIFont defaultSubtitleFont];
	self.quantityLabel.font = [UIFont defaultSubtitleFont];

	[self unselected];
}

- (void)selected {
	self.nameLabel.textColor = [UIColor black75PercentColor];
	self.quantityLabel.textColor = [UIColor black75PercentColor];
}

- (void)unselected {
	self.nameLabel.textColor = [UIColor applicationColor];
	self.quantityLabel.textColor = [UIColor defaultFontColor];
}

- (void)configureName:(NSString *)name quantity:(NSString *)quantity {
	self.nameLabel.text = name;
	self.quantityLabel.text = quantity;
}

@end
