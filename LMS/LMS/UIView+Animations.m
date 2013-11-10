//
//  UIView+Animations.m
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UIView+Animations.h"

static float kDefaultAnimationDuration = 0.5;
static float kDefaultDelayDuration = 0.1;

@implementation UIView (Animations)

- (CGRect)frameForAnimateRect:(UIViewPosition)position {
	CGRect animateRect = self.frame;
	
	switch (position) {
		case leftPosition:
		{
			animateRect.origin.y = self.frame.origin.y;
			animateRect.origin.x -= animateRect.size.width;
		}
			break;
		case rightPosition:
		{
			animateRect.origin.y = self.frame.origin.y;
			animateRect.origin.x += animateRect.size.width;
		}
			break;
		case topPosition:
		{
			animateRect.origin.x = self.frame.origin.x;
			animateRect.origin.y += animateRect.size.height;

		}
			break;
		case bottomPosition:
		{
			animateRect.origin.x = self.frame.origin.x;
			animateRect.origin.y -= animateRect.size.height;

		}
			break;
			
		default:
		{
			//INFO: error
		}
			break;
	}
	return animateRect;
}

- (void)animateFromPosition:(UIViewPosition)position {
	
	NSLog(@"%s | %@", __PRETTY_FUNCTION__, self);
	
	[UIView animateWithDuration:kDefaultAnimationDuration
						  delay:kDefaultDelayDuration
						options: UIViewAnimationOptionCurveEaseOut//UIViewAnimationCurveEaseOut
					 animations:^{
						 /*
						 CGRect frame = self.frame;
						 frame.origin.y = self.frame.origin.y;
						 if (left == NO) {
							 frame.origin.x += frame.size.width;
						 }
						 else {
							 frame.origin.x -= frame.size.width;
						 }
						  */
						 self.frame = [self frameForAnimateRect:position];//frame;
					 }
					 completion:^(BOOL finished) {
						 DLog(@"complete animation");
						 
					 }];
}

@end
