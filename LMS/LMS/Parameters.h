//
//  Parameters.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"
#import "ApiUrls.h"
#import "ApiKeys.h"
#import "Languages.h"
#import "Pages.h"
#import "Descriptions.h"
#import "KeyWords.h"


@interface Parameters : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) Languages *languages;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) ApiUrls *apiUrls;
@property (strong, nonatomic) ApiKeys *apiKeys;
@property (strong, nonatomic) Pages *pages;
@property (strong, nonatomic) Descriptions *descriptions;
@property (strong, nonatomic) KeyWords *keyWords;

@end
