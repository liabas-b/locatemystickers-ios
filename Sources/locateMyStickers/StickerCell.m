//
//  StickerCell.m
//  LMS
//
//  Created by Adrien Guffens on 2/25/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerCell.h"
#import "BButton.h"

@implementation StickerCell

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
	[self.mapButton setType:BButtonTypeDefault];
	[self.mapButton setColor:[UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0]];
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
	backgroundView.backgroundColor = [UIColor colorWithRed:162/255.0 green:36.0/255.0 blue:60.0/255.0 alpha:1.0];
	self.selectedBackgroundView = backgroundView;

}

- (IBAction)handlerMapButton:(id)sender {
}

@end
