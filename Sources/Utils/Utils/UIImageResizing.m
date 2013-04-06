//
//  UIImageResizing.m
//  Utils
//
//  Created by Adrien Guffens on 11/1/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "UIImageResizing.h"

@implementation UIImage (Resize)

- (UIImage *)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

@end
