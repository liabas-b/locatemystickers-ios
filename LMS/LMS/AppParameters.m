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
//#import "NetworkKeys.h"
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
		
//		@try {
			NSString* path = [[NSBundle mainBundle] pathForResource:@"lms"
															 ofType:@"json"];
			NSString* content = [NSString stringWithContentsOfFile:path
														  encoding:NSUTF8StringEncoding
															 error:NULL];
			NSError* error = nil;
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
			DLog(@"error: %@", error);
			NSLog(@"JSON: %@", json);
			
			
			error = nil;
			self.parameters = [[Parameters alloc] initWithDictionary:json error:&error];
			
			DLog(@"param.networkKeys.googleAnalyticsApiKey: %@", self.parameters.apiKeys.googleAnalyticsApiKey);

			DLog(@"error: %@", error);
			DLog(@"parameters: %@", self.parameters);
			
//			OperationManager *op = [OperationManager new];
//			[op start];
			
//			[op enqueueWithData:self.parameters forTask:@"AppParameters"];
			
			NSArray *arr = [NSArray arrayWithContentsOfFile:content];
			DLog(@"%@", arr);

//		}
		/*@catch (NSException *exception) {
			DLog(@"exception: %@", exception);
		}
		@finally {
			
		}
		*/
		return self;
		
//		NSString *content;
		NSDictionary *plistContent = [NSDictionary dictionaryWithContentsOfFile:content];
        NSDictionary *parameters = [[plistContent objectForKey:@"data"] objectAtIndex:0];
        NSDictionary *dictionnary;
		
		DLog(@"plistContent: %@", plistContent);
        
    
        
        NSLog(@"%s | %@", __PRETTY_FUNCTION__, parameters);
        
        _color = [parameters objectForKey:@"color"];
        
        
        _eventID = [parameters objectForKey:@"event"];
        
        dictionnary = [[parameters objectForKey:@"network_keys"] firstObject];
        if (dictionnary)
        {
            _googleAnalyticsKey = [dictionnary objectForKey:@"google_analytics_api_key"];
        }
        
        dictionnary = [[parameters objectForKey:@"pages"] firstObject];
        if (dictionnary)
        {
            NSMutableDictionary *dictioToSort = [NSMutableDictionary dictionaryWithDictionary:dictionnary];
            [dictionnary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                NSNumber *menuValue = obj;
                
                if (menuValue.integerValue == -1)
                {
                    [dictioToSort removeObjectForKey:key];
                }
            }];
            
            _menuItemOrder = [dictioToSort keysSortedByValueUsingSelector:@selector(compare:)];
        }
        
        _liveMessagesEnable = @([[parameters objectForKey:@"live_messages"] boolValue]);
        _loginType = [[parameters objectForKey:@"login"] integerValue];
        
        
   
        
        //Get current local language and match with supported language by the app. if language not found put default language.
        _phoneLocalLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
   
        NSArray *languageSupported = [[[parameters objectForKey:@"languages"] firstObject] allValues];
        
        NSLog(@"%s | languageSupported: %@", __PRETTY_FUNCTION__, languageSupported);
        
        if ([languageSupported indexOfObject:_phoneLocalLanguage] == NSNotFound)
        {
           _phoneLocalLanguage = [languageSupported firstObject];
            
        }
    }
    
    NSLog(@"%s | [self description]: %@", __PRETTY_FUNCTION__, [self description]);
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%s | _eventID %d, _googleAnalyticsKey: %@, _menuItemOrder: %@, _loginType: %d, _phoneLocalLanguage: %@, _color: %@", __PRETTY_FUNCTION__, [_eventID intValue] , _googleAnalyticsKey, _menuItemOrder, _loginType, _phoneLocalLanguage, _color];
}

@end
