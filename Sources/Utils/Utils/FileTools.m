//
//  FileTools.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "FileTools.h"

@implementation FileTools

#pragma mark - fileExist

+ (BOOL)fileExist:(NSString *)aFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	return ([fileManager fileExistsAtPath:aFile]);
}

#pragma mark - createDirectory

+ (BOOL)createDirectory:(NSString *)directory {
	BOOL isDir = YES;
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	
	if (![fileManager fileExistsAtPath:directory isDirectory:&isDir])
		if (![fileManager createDirectoryAtPath:directory
					withIntermediateDirectories:NO
									 attributes:nil
										  error:NULL]) {
			NSLog(@"Error: Create folder failed %@", directory);
			return NO;
		}
	return YES;
}

+ (BOOL)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath {
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
	
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
		return FALSE;	
	}
	return TRUE;
}

#pragma mark - extractFile to Documents

+ (void)extractFile:(NSString *)fileName replace:(BOOL)replaceIfExist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSError *error;
	
    if (documentsDirectory) {
		NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:fileName];
		
		if ([fileManager fileExistsAtPath:txtPath] == YES && replaceIfExist) {
			[fileManager removeItemAtPath:txtPath error:&error];
		}
		
		if ([fileManager fileExistsAtPath:txtPath] == NO) {
			NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
			[fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
		}
	}
}

+ (NSString *)getFilePath:(NSString *)aFile andType:(NSString *)type {
    NSString *filePath = [[NSBundle mainBundle] pathForResource: aFile ofType:type];
	
    return filePath;
}

+ (NSData *)getFile:(NSString *)aFile andType:(NSString *)type {
    NSData * file = [NSData dataWithContentsOfFile: [FileTools getFilePath:aFile andType:type]];
	
    return file;
}

+ (NSString *)getFilePathFromDocument:(NSString *)aFile andType:(NSString *)type {
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	return ([docsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", aFile, type]]);
}

+ (NSString *)getFilePathFromDocument:(NSString *)aFile {
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	return ([docsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aFile]]);
}

+ (BOOL)removeFile:(NSString *)aFile andType:(NSString *)type {
	NSString *path = [FileTools getFilePath:aFile andType:type];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:path])
		return ([fileManager removeItemAtPath:path error:NULL]);
	return (FALSE);
}

+ (BOOL)removeFileFromDocument:(NSString *)aFile andType:(NSString *)type {
	NSString *path = [FileTools getFilePathFromDocument:aFile andType:type];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:path])
		return ([fileManager removeItemAtPath:path error:NULL]);
	return (FALSE);
}

 @end
