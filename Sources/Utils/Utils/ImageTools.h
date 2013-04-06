//
//  ImageTools.h
//  Utils
//
//  Created by Adrien Guffens on 11/1/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface ImageTools : NSObject

+ (void)addBorderToLayer:(CALayer *)layer withBorderRaduis:(float)radius;

+ (void)addBorderToView:(UIView *)view withBorderRaduis:(float)radius;
+ (void)addBorderToView:(UIView *)view andSubviews:(BOOL)subviewEnable withBorderRaduis:(float)radius;

@end
