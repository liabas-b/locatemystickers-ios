//
//  RoundedImageView.h
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "RoundedImageView.h"

@interface RoundedImageView ()

- (void)setupViewLayers;

@end

@implementation RoundedImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViewLayers];
    }
    return self;
}

- (void)setupViewLayers {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 3.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.cornerRadius = roundf(self.frame.size.width / 2.0);
}

@end
