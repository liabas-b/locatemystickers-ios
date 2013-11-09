//
//  UIColor+AppColor.h
//  wonderapp
//
//  Created by MEETINEO on 22/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Colours.h"

@interface UIColor (AppColor)

//INFO: Default
+ (UIColor *)defaultColor;
+ (UIColor *)defaultTitleColor;
+ (UIColor *)defaultFontColor;
+ (UIColor *)defaultSelectedFontColor;

//INFO: Global
+ (UIColor *)applicationColor;
+ (UIColor *)navigationBar;
+ (UIColor *)subNavigationBar;
+ (UIColor *)iconColor;
+ (UIColor *)buttonFontColor;

//INFO: Menu
+ (UIColor *)menuBackGroundColor;
+ (UIColor *)menuSeparatorColor;
+ (UIColor *)menuCellSelectedColor;
+ (UIColor *)generalCustomColor;

//INFO: Textfield Flat
+ (UIColor *)textFieldBorderColor;

//INFO: Button
+ (UIColor *)buttonBackgroundColor;
+ (UIColor *)timelineBarColor;

@end
