//
//  UIFont+AppFont.m
//  wonderapp
//
//  Created by MEETINEO on 30/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import "UIFont+AppFont.h"
#import "UIFont+FlatUI.h"
#import <CoreText/CoreText.h>


/*
 install_resource "BButton/BButton/resources/FontAwesome.ttf"
 

// install_resource "FlatUIKit/Resources/Lato-Black.ttf"
// install_resource "FlatUIKit/Resources/Lato-BlackItalic.ttf"
 install_resource "FlatUIKit/Resources/Lato-Bold.ttf"
 install_resource "FlatUIKit/Resources/Lato-BoldItalic.ttf"
 install_resource "FlatUIKit/Resources/Lato-Hairline.ttf"
 install_resource "FlatUIKit/Resources/Lato-HairlineItalic.ttf"
// install_resource "FlatUIKit/Resources/Lato-Italic.ttf"
 install_resource "FlatUIKit/Resources/Lato-Light.ttf"
 install_resource "FlatUIKit/Resources/Lato-LightItalic.ttf"
// install_resource "FlatUIKit/Resources/Lato-Regular.ttf"
 */
 
static NSString *kDefaultFont = @"Lato-Regular";
static NSString *kDefaultItalicFont = @"Lato-Italic";
static NSString *kDefaultBoldFont = @"Lato-Bold";
static NSString *kDefaultLightFont = @"Lato-Light";
static NSString *kDefaultHairlineFont = @"Lato-Hairline";

@implementation UIFont (AppFont)

/*
+ (UIFont *)flatFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"Lato-Regular" withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}
*/
//INFO: Global

+ (UIFont*)defaultFont
{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });

    return [UIFont fontWithName:kDefaultFont size:15.0];
//	return [UIFont fontWithName:@"HelveticaNeue" size:15];
}

+ (UIFont*)defaultSelectedFont
{
	
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultLightFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
	
    return [UIFont fontWithName:kDefaultLightFont size:15.0];
//    return [UIFont fontWithName:@"lato-light" size:15.0];
}

+ (UIFont*)defaultSmallFont
{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultHairlineFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
	
    return [UIFont fontWithName:kDefaultHairlineFont size:15.0];
	//	return [UIFont fontWithName:@"lato-hairline" size:30.0];
}

+ (UIFont*)defaultTitleFont
{
//	return [UIFont fontWithName:@"HelveticaNeue" size:20];
//    return [UIFont fontWithName:@"lato-light" size:20.0];
	
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultLightFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    return [UIFont fontWithName:kDefaultLightFont size:20.0];
	
}

+ (UIFont*)defaultSubtitleFont
{
	return [UIFont lightFont];
}

+ (UIFont*)lightFont
{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultHairlineFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    return [UIFont fontWithName:kDefaultHairlineFont size:15.0];
	
//    return [UIFont fontWithName:@"lato-hairline" size:15.0];
}

+ (UIFont*)mediumFont
{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultHairlineFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    return [UIFont fontWithName:kDefaultHairlineFont size:15.0];
//    return [UIFont fontWithName:@"lato-light" size:15.0];
}

+ (UIFont*)navBarFont
{
    //INFO: Minuscule avec majuscule au début
//    return [UIFont fontWithName:@"lato-hairline" size:27.0];
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultHairlineFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    return [UIFont fontWithName:kDefaultHairlineFont size:27.0];
//	return  [UIFont flatFontOfSize:27.0];
//	return [UIFont fontWithName:@"Lato-Hairline" size:27.0];
}

+ (UIFont*)buttonFont
{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:kDefaultLightFont withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    return [UIFont fontWithName:kDefaultLightFont size:15.0];
//    return [UIFont fontWithName:@"lato-light" size:15.0];
}

@end
