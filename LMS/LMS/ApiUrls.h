//
//  ApiUrls.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol ApiUrls
@end

@interface ApiUrls : JSONModel

@property (strong, nonatomic) NSString *lmsApi;
@property (strong, nonatomic) NSString *lmsStickersApi;
@property (strong, nonatomic) NSString *lmsLiveApi;

@end
