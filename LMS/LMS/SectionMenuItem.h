//
//  SectionMenuItem.h
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol SectionMenuItem
@end

@interface SectionMenuItem : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) int section;
@property (strong, nonatomic) NSString *language;

@end
