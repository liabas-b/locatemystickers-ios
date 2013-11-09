//
//  Pages.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol MenuItem
@end

@interface MenuItem : JSONModel

@property (strong, nonatomic) NSString *controller;
@property (assign, nonatomic) int section;
@property (assign, nonatomic) int row;
@property (strong, nonatomic) NSString *language;

@end
