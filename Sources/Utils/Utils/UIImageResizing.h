//
//  UIImageResizing.h
//  Utils
//
//  Created by Adrien Guffens on 11/1/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)scaleToSize:(CGSize)size;

@end