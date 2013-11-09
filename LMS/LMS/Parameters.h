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

#import "MenuItem.h"
#import "KeyWordItem.h"
#import "DescriptionItem.h"
#import "LanguageItem.h"
#import "SectionMenuItem.h"


@interface Parameters : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *backgroundColor;
@property (strong, nonatomic) NSArray<LanguageItem> *languages;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) ApiUrls *apiUrls;
@property (strong, nonatomic) ApiKeys *apiKeys;
@property (strong, nonatomic) NSArray<SectionMenuItem> *sectionsMenu;
@property (strong, nonatomic) NSArray<MenuItem> *menu;
@property (strong, nonatomic) NSArray<DescriptionItem> *descriptions;
@property (strong, nonatomic) NSArray<KeyWordItem> *keyWords;

@end
