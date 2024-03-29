//
//  UIColor+AppColor.m
//  wonderapp
//
//  Created by MEETINEO on 22/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import "UIColor+AppColor.h"
#import "AppDelegate.h"

@implementation UIColor (AppColor)


//INFO: Default

+ (UIColor *)defaultColor
{
    return [UIColor colorFromHexString:@"#707070"];
}

+ (UIColor *)defaultTitleColor
{
    return [UIColor colorFromHexString:@"#3E444B"];
}


+ (UIColor *)defaultFontColor
{
    return [UIColor colorFromHexString:@"#7F8995"];
}

+ (UIColor *)defaultSelectedFontColor
{
    return [UIColor colorFromHexString:@"#E0E0E0"];
}

//INFO: Global

+ (UIColor *)applicationColor {
	AppDelegate *appDelegate = (AppDelegate *)[AppDelegate appDelegate];
	NSString *color = appDelegate.appParameters.parameters.color;

	return [UIColor colorFromHexString:color];
}

+ (UIColor *)backgroundColor {
	AppDelegate *appDelegate = (AppDelegate *)[AppDelegate appDelegate];
	NSString *color = appDelegate.appParameters.parameters.backgroundColor;
	
	return [UIColor colorFromHexString:color];
}

+ (UIColor *)navigationBar
{
    return [UIColor colorFromHexString:@"#495762"];
}

+ (UIColor *)subNavigationBar
{
    return [UIColor colorFromHexString:@"#6f7985"];
}

+ (UIColor *)iconColor
{
    //INFO: Couleur Typo et icones
    return [UIColor whiteColor];
}

+ (UIColor *)buttonFontColor
{
    //INFO: Couleur Typo et icones
    return [UIColor whiteColor];
}

//INFO: Menu

+ (UIColor *)menuBackGroundColor
{
    return [UIColor colorFromHexString:@"#51616d"];
}

+ (UIColor *)menuSeparatorColor //INFO:  & fonction - company
{
    return [UIColor colorFromHexString:@"#62717c"];
}

+ (UIColor *)menuCellSelectedColor
{
    return [UIColor colorFromHexString:@"#495762"];
}

+ (UIColor *)generalCustomColor
{
    return [UIColor colorFromHexString:@"#FB642A"];
}

//INFO: Textfield Flat

+ (UIColor *)textFieldBorderColor
{
    return [UIColor colorFromHexString:@"C8C9CB"];
}

//INFO: Button

+ (UIColor *)buttonBackgroundColor
{
    return [UIColor colorFromHexString:@"#FC6521"];
}

+ (UIColor *)timelineBarColor
{
    return [UIColor colorFromHexString:@"#E0E0E0"];
}

@end
