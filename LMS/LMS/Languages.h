//
//  Languages.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol Languages
@end

@interface Languages : JSONModel

@property (strong, nonatomic) NSString *fr;
@property (strong, nonatomic) NSString *en;

@end
