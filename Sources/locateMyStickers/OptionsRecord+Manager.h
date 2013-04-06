//
//  OptionsRecord+Manager.h
//  LMS
//
//  Created by Adrien Guffens on 4/6/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "OptionsRecord.h"

@interface OptionsRecord (Manager)

+ (OptionsRecord *)addUpdateOptionsWithDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)moc;

+ (NSArray *)optionsRecordsInManagedObjectContext:(NSManagedObjectContext *)moc;

@end
