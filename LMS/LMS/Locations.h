//
//  Locations.h
//  LMS
//
//  Created by Adrien Guffens on 15/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"
#import "LMSLocation.h"

@interface Locations : JSONModel

@property (strong, nonatomic) NSArray<LMSLocation> *locations;

@end
