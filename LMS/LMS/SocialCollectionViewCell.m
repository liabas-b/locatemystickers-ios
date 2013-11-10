//
//  SocialCollectionViewCell.m
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "SocialCollectionViewCell.h"

@implementation SocialCollectionViewCell

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
		
		[UIView animateWithDuration:0.8
							  delay:0
							options:(UIViewAnimationOptionAllowUserInteraction)
						 animations:^{
//							 self.titleLabel.font = [UIFont defaultSelectedFont];
//							 self.titleLabel.textColor = [UIColor defaultSelectedFontColor];
//							 self.selectedImageView.hidden = NO;
//							 
//							 self.backgroundColor = self.selectedColor;
						 }
						 completion:^(BOOL finished){
							 
						 }];
    } else {
		
		[UIView animateWithDuration:0.8
							  delay:0
							options:(UIViewAnimationOptionAllowUserInteraction)
						 animations:^{
//							 self.titleLabel.font = [UIFont defaultFont];
//							 self.titleLabel.textColor = [UIColor defaultFontColor];
//							 self.selectedImageView.hidden = YES;
//							 
//							 self.backgroundColor = self.defaultColor;
							 
							 [self layoutIfNeeded];
						 }
						 completion:^(BOOL finished){
							 
						 }];
    }
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
