//
//  UIView+Animations.h
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	leftPosition = 1,
	rightPosition,
	topPosition,
	bottomPosition,
} UIViewPosition;

@interface UIView (Animations)

- (void)animateFromPosition:(UIViewPosition)position;

@end
