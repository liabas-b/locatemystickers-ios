//
//  UIDevice+VersionCheck.m
//  wonderapp
//
//  Created by MEETINEO on 23/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import "UIDevice+VersionCheck.h"

@implementation UIDevice (VersionCheck)

- (NSUInteger)systemMajorVersion
{
    NSString * versionString;
    
    versionString = [self systemVersion];
    
    return [versionString integerValue];
}

@end
