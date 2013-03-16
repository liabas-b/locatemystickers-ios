//
//  StickerCell.m
//  LMS
//
//  Created by Adrien Guffens on 2/25/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerCell.h"

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
}

- (IBAction)handlerMapButton:(id)sender {
}

@end
