//
//  UserToolsCollectionCell.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UserToolsCollectionViewCell.h"

@implementation UserToolsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	
	if (selected) {
		
		[UIView animateWithDuration:0.5
							  delay:0
							options:(UIViewAnimationOptionCurveEaseIn)
						 animations:^{
							 [self.userToolsView selected];
						 }
						 completion:^(BOOL finished1) {
							 
						 }];
		
		
	}
	else {
		[UIView animateWithDuration:0.5
							  delay:0
							options:(UIViewAnimationOptionCurveEaseOut)
						 animations:^{
							 [self.userToolsView unselected];
						 }
						 completion:^(BOOL finished1) {
							 
						 }];
		
	}
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
	[super setSelectedBackgroundView:selectedBackgroundView];
}

@end
