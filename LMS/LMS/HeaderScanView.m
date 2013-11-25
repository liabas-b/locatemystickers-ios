//
//  HeaderScanView.m
//  LMS
//
//  Created by Adrien Guffens on 25/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "HeaderScanView.h"

@implementation HeaderScanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if (self.backHandler) {
		self.backHandler(self);
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
