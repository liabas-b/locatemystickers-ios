//
//  UIFont+AppFont.m
//  wonderapp
//
//  Created by MEETINEO on 30/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import "UIFont+AppFont.h"

@implementation UIFont (AppFont)

//INFO: Global

+ (UIFont*)defaultFont
{
    return [UIFont fontWithName:@"lato-regular" size:15.0];
//	return [UIFont fontWithName:@"HelveticaNeue" size:15];
}

+ (UIFont*)defaultSelectedFont
{
    return [UIFont fontWithName:@"lato-light" size:15.0];
}

+ (UIFont*)defaultSmallFont
{
	return [UIFont fontWithName:@"lato-hairline" size:13.0];
}

+ (UIFont*)defaultTitleFont
{
//	return [UIFont fontWithName:@"HelveticaNeue" size:20];
    return [UIFont fontWithName:@"lato-light" size:20.0];
}

+ (UIFont*)defaultSubtitleFont
{
	return [UIFont lightFont];
}

+ (UIFont*)lightFont
{
    return [UIFont fontWithName:@"lato-hairline" size:15.0];
}

+ (UIFont*)mediumFont
{
    return [UIFont fontWithName:@"lato-light" size:15.0];
}

+ (UIFont*)navBarFont
{
    //INFO: Minuscule avec majuscule au début
    return [UIFont fontWithName:@"lato-hairline" size:27.0];
}

+ (UIFont*)buttonFont
{
    return [UIFont fontWithName:@"lato-light" size:15.0];
}

@end
