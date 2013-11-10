//
//  LMSMenuCell.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSMenuCell.h"

@implementation LMSMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	[self setSelected:YES animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	[self setSelected:NO animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
    if (selected == YES) {
		[UIView animateWithDuration:0.8
							  delay:0
							options:(UIViewAnimationOptionAllowUserInteraction)
						 animations:^{
							 
							 //							 self.menuLabel.font = [UIFont defaultSelectedFont];
							 self.menuLabel.textColor = [UIColor whiteColor];
							 self.backgroundColor = [UIColor backgroundColor];
							 
							 //							 [self layoutIfNeeded];
						 }
						 completion:^(BOOL finished){
							 [self layoutIfNeeded];
							 
							 //							 self.backgroundColor = [UIColor redColor];
						 }];
	}
	else {
		[UIView animateWithDuration:0.8
							  delay:0
							options:(UIViewAnimationOptionAllowUserInteraction)
						 animations:^{
							 //							 self.menuLabel.font = [UIFont defaultSelectedFont];
							 self.menuLabel.textColor = [UIColor defaultFontColor];
							 
							 self.backgroundColor = [UIColor clearColor];
						 }
						 completion:^(BOOL finished){
							 [self layoutIfNeeded];
							 
						 }];
	}
	
	
	
}

@end
