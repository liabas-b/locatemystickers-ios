//
//  FileTools.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

@interface FileTools : NSObject

+ (BOOL)fileExist:(NSString *)aFile;
+ (BOOL)createDirectory:(NSString *)directory;
+ (BOOL)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath;
+ (void)extractFile:(NSString *)fileName replace:(BOOL)replaceIfExist;

+ (NSString *)getFilePath:(NSString *)aFile andType:(NSString *)type;
+ (NSData *)getFile:(NSString *)aFile andType:(NSString *)type;

+ (NSString *)getFilePathFromDocument:(NSString *)aFile andType:(NSString *)type;
+ (NSString *)getFilePathFromDocument:(NSString *)aFile;

+ (BOOL)removeFile:(NSString *)aFile andType:(NSString *)type;
+ (BOOL)removeFileFromDocument:(NSString *)aFile andType:(NSString *)type;

@end
