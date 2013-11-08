//
//  Pages.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol Pages
@end

@interface Pages : JSONModel

@property (strong, nonatomic) NSString *map;
@property (strong, nonatomic) NSString *stickers;
@property (strong, nonatomic) NSString *users;
@property (strong, nonatomic) NSString *settings;
@property (strong, nonatomic) NSString *search;

@end
