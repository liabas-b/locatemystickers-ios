//
//  LMSMapViewButton.m
//  LMS
//
//  Created by Adrien Guffens on 02/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "LMSMapViewButton.h"

@interface LMSMapViewButton ()



@end

@implementation LMSMapViewButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self configure];
		[self configureView];
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self configure];
}

- (void)configure {
	self.isToggled = NO;
	[self configureView];
}

- (void)configureView {
	[super configureView];
	self.buttonLabel.font = [UIFont defaultFont];
	self.buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.buttonLabel.numberOfLines = 1;
	self.buttonLabel.textColor = [UIColor defaultFontColor];
}

- (void)setButtonImage:(UIImage *)image withButtonValue:(NSString *)buttonValue {
	self.buttonImageView.image = image;
	self.buttonLabel.text = [buttonValue uppercaseString];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if (self.isToggled == YES) {
		self.isToggled = NO;
		[UIView animateWithDuration:0.8
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
							 self.backgroundColor = [UIColor clearColor];
							 self.layer.opacity = 1.0;
							 self.buttonLabel.textColor = [UIColor defaultFontColor];
							 self.buttonImageView.layer.opacity = 1.0;
                         } completion:^(BOOL finished) {
							 
                         }];
		
	}
	else {
		self.isToggled = YES;
		[UIView animateWithDuration:0.8
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
							 UIColor *color = [UIColor colorWithWhite:0.5 alpha:0.5];//[UIColor applicationColor];

							 self.backgroundColor = color;
							 self.layer.opacity = 0.6;
							 self.buttonLabel.textColor = [UIColor defaultSelectedFontColor];
							 self.buttonImageView.layer.opacity = 0.6;
                         } completion:^(BOOL finished) {
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
