//
//  LMSMapCollectionViewCell.m
//  LMS
//
//  Created by Adrien Guffens on 10/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapCollectionViewCell.h"
#import "UIFont+AppFont.h"
#import "UIColor+AppColor.h"

@implementation LMSMapCollectionViewCell

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
	
	self.titleLabel.font = [UIFont defaultFont];
	self.titleLabel.textColor = [UIColor defaultFontColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
	
    if (selected) {
		
		[UIView animateWithDuration:0.8
							  delay:0
							options:(UIViewAnimationOptionAllowUserInteraction)
						 animations:^{
							 self.titleLabel.font = [UIFont defaultSelectedFont];
							 self.titleLabel.textColor = [UIColor defaultSelectedFontColor];
							 self.selectedImageView.hidden = NO;
							 
							 self.backgroundColor = self.selectedColor;
						 }
						 completion:^(BOOL finished){
							 
						 }];
    } else {

		[UIView animateWithDuration:0.8
							  delay:0
							options:(UIViewAnimationOptionAllowUserInteraction)
						 animations:^{
							 self.titleLabel.font = [UIFont defaultFont];
							 self.titleLabel.textColor = [UIColor defaultFontColor];
							 self.selectedImageView.hidden = YES;
							 
							 self.backgroundColor = self.defaultColor;
							 
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
