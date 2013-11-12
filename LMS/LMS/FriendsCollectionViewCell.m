//
//  FriendsCollectionViewCell.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "FriendsCollectionViewCell.h"

@implementation FriendsCollectionViewCell

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
	self.nameLabel.font = [UIFont defaultSmallFont];
	
	[self unselected];
}

- (void)setSelected:(BOOL)selected {
	if (selected) {
		[self selected];
	} else {
		[self unselected];
	}
}

- (void)selected {
	self.nameLabel.textColor = [UIColor black75PercentColor];
}

- (void)unselected {
	self.nameLabel.textColor = [UIColor applicationColor];
}

- (void)configureName:(NSString *)name quantity:(NSString *)quantity {
	self.nameLabel.text = name;
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
