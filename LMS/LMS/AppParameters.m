//
//  AppParameters.m
//  wonderapp
//
//  Created by MEETINEO on 12/08/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import "AppParameters.h"
#import "Parameters.h"
#import "OperationManager.h"
#import "ApiUrls.h"
#import "ApiKeys.h"

@implementation AppParameters

+ (AppParameters*)defaultParameters
{
    static AppParameters *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

- (id)init {
    self = [super init];
    if (self)
    {
		
		@try {
			NSString* path = [[NSBundle mainBundle] pathForResource:@"lms"
															 ofType:@"json"];
			NSString* content = [NSString stringWithContentsOfFile:path
														  encoding:NSUTF8StringEncoding
															 error:NULL];
			NSError* error = nil;
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
			
			error = nil;
			self.parameters = [[Parameters alloc] initWithDictionary:json error:&error];
			
			[self cofigureLists];
			
			DLog(@"error: %@", error);
			DLog(@"parameters: %@", self.parameters);
			
			DLog(@"sectionsList: %@", self.sectionsList);
			DLog(@"menuList: %@", self.menuList);
			
		}
		@catch (NSException *exception) {
			DLog(@"exception: %@", exception);
		}
		@finally {

		}
	}
	return self;
}

- (void)cofigureLists {
	NSMutableArray *sectionsMenu = [[NSMutableArray alloc] initWithArray:self.parameters.sectionsMenu];
	
	[sectionsMenu enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SectionMenuItem *sectionMenu = (SectionMenuItem *)obj;
		if (sectionMenu.section == -1)
			[sectionsMenu removeObject:sectionMenu];
	}];
	
	NSArray *sortedSectionsMenu = [sectionsMenu sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(id obj1, id obj2) {
		int section1 = ((SectionMenuItem *)obj1).section;
		int section2 = ((SectionMenuItem *)obj2).section;
		
		if (section1 == section2) return NSOrderedSame;
		return (section1 < section2) ? NSOrderedAscending : NSOrderedDescending;
	}];
	
	DLog(@"sortedSectionsMenu:");
	[sortedSectionsMenu enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		DLog(@"obj: %@ | idx: %d", obj, idx);
	}];
	
	self.sectionsList = [[NSMutableArray alloc] initWithArray:sortedSectionsMenu];
	
	self.menuList = [[NSMutableArray alloc] init];
	
	for (SectionMenuItem *sectionMenuItem in sortedSectionsMenu) {
		DLog(@"sectionMenuItem: %@", [sectionMenuItem description]);
		NSMutableArray *rows = [[NSMutableArray alloc] init];
		NSArray *menusItem = self.parameters.menu;
		for (MenuItem *menuItem in menusItem) {
			if (menuItem.section == sectionMenuItem.section) {
				DLog(@"add object: %@", menuItem);
				[rows addObject:menuItem];
			}
		}
		[self.menuList addObject:rows];
	}
	
	NSMutableArray *finalList = [[NSMutableArray alloc] init];
	[self.menuList enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSMutableArray *rows = (NSMutableArray *)obj;
		
		NSArray *sortedRows = [rows sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(id obj1, id obj2) {
			int row1 = ((MenuItem *)obj1).row;
			int row2 = ((MenuItem *)obj2).row;
			
			if (row1 == row2) return NSOrderedSame;
			return (row1 < row2) ? NSOrderedAscending : NSOrderedDescending;
		}];
		[finalList addObject:sortedRows];
	}];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%s | parameters %@ - sectionsList: %@ - menuList: %@", __PRETTY_FUNCTION__, self.sectionsList , self.menuList];
}

@end
