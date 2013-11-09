//
//  PopUpLoginView.m
//  AB
//
//  Created by Adrien Guffens on 1/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "PopUpLoginView.h"

@implementation PopUpLoginView

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
//	self.alpha = 1.0;
	
//    self.navigationBar add
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)cancelButtonHandler:(id)sender {
	[UIView animateWithDuration:0.8
					 animations:^{
						 self.alpha = 0.0;
	} completion:^(BOOL finished) {
	}];

}

@end
