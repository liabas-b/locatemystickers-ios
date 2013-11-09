//
//  KeyWordItem.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol KeyWordItem
@end

@interface KeyWordItem : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *value;

@end
