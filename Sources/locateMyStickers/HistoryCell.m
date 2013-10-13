//
//  HistoryCell.m
//  LMS
//
//  Created by Adrien Guffens on 9/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "HistoryCell.h"

#import "UIFont+AppFont.h"
#import "UIColor+AppColor.h"

@implementation HistoryCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	
	self.historyLabel.font = [UIFont defaultFont];
	//	self.nameLabel.textColor = [UIColor defaultFontColor];
	
	
	self.dateLabel.font = [UIFont mediumFont];
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
}

@end
