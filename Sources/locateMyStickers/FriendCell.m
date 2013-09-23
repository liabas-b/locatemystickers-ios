//
//  FriendCell.m
//  LMS
//
//  Created by Adrien Guffens on 9/20/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
	UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
	backgroundView.backgroundColor = [UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
	self.selectedBackgroundView = backgroundView;
}

@end
