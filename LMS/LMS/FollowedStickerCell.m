//
//  FollowedStickerCell.m
//  LMS
//
//  Created by Adrien Guffens on 9/22/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "FollowedStickerCell.h"

#import "UIFont+AppFont.h"
#import "UIColor+AppColor.h"

@implementation FollowedStickerCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	
	self.nameLabel.font = [UIFont defaultFont];
	//	self.nameLabel.textColor = [UIColor defaultFontColor];
	
	
	self.timeLabel.font = [UIFont mediumFont];
	//	self.timeLabel.textColor = [UIColor defaultFontColor];
}

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
