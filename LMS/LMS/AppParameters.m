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

- (id)init
{
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
			
			DLog(@"error: %@", error);
			DLog(@"parameters: %@", self.parameters);
			
		}
		@catch (NSException *exception) {
			DLog(@"exception: %@", exception);
		}
		@finally {
			
		}
	}
	return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%s | _eventID %d, _googleAnalyticsKey: %@, _menuItemOrder: %@, _loginType: %d, _phoneLocalLanguage: %@, _color: %@", __PRETTY_FUNCTION__, [_eventID intValue] , _googleAnalyticsKey, _menuItemOrder, _loginType, _phoneLocalLanguage, _color];
}

@end
