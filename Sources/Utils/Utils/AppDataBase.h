//
//  AppData.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataBaseConnector;
@class ConfigManager;

@interface AppDataBase : NSObject

@property(nonatomic, strong)NSString *ApplicationDirectory;

@property(nonatomic, strong)DataBaseConnector *DataBaseConnector;
@property(nonatomic, strong)ConfigManager *ConfigManager;

@property(nonatomic, strong)NSString *FileDirectory;

@end
