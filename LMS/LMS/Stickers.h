//
//  Stickers.h
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"
#import "LMSSticker.h"

@interface Stickers : JSONModel

@property (strong, nonatomic) NSArray<LMSSticker> *stickers;

@end
