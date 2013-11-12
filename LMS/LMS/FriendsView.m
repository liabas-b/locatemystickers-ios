//
//  FriendsView.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "FriendsView.h"

@implementation FriendsView

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
	self.friendsLabel.font = [UIFont defaultTitleFont];
	self.friendsLabel.textColor = [UIColor defaultFontColor];
}

- (void)configureWithFriendList:(NSArray *)friendList {
	[self.friendsCollectionView configureWithFriendList:friendList];
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
