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
#import "Languages.h"
#import "Pages.h"
#import "Descriptions.h"
#import "KeyWords.h"

/*
 "facebook_api_key": "key",
 "facebook_app_secret": "secret",
 "google_analytics_api_key": "UA-45542059-1",
 "twitter_oauth_access_token": "token",
 "twitter_oauth_access_token_secret": "",
 "twitter_consumer_key": "key",
 "twitter_consumer_secret": "secrete"
 */
@interface Parameters : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) Languages *languages;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) ApiUrls *apiUrls;
@property (strong, nonatomic) ApiKeys *apiKeys;
@property (strong, nonatomic) Pages *pages;
@property (strong, nonatomic) Descriptions *descriptions;
@property (strong, nonatomic) KeyWords *keyWords;
/*
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSArray<NSDictionary, ConvertOnDemand> *languages;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSArray<NSDictionary, ConvertOnDemand> *networkKeys;
@property (strong, nonatomic) NSArray<NSDictionary, ConvertOnDemand> *pages;
@property (strong, nonatomic) NSArray<NSDictionary, ConvertOnDemand> *description;
@property (strong, nonatomic) NSArray<NSDictionary, ConvertOnDemand> *keyWords;
*/
/*
 {
 "color": "#8F142F",
 "languages": [
 {
 "1": "fr",
 "2": "en"
 }
 ],
 "theme": "2",
 "network_keys": [
 {
 "facebook_api_key": "key",
 "facebook_app_secret": "secret",
 "google_analytics_api_key": "UA-45542059-1",
 "twitter_oauth_access_token": "token",
 "twitter_oauth_access_token_secret": "",
 "twitter_consumer_key": "key",
 "twitter_consumer_secret": "secrete"
 }
 ],
 "pages": [
 {
 "1": "1",
 "2": "2",
 "3": "-1",
 "4": "4",
 "5": "3"
 }
 ],
 "description": [
 {
 "fr": "Locate My Sticker est un outil pour localiser des stickers",
 "en": "Locate My Sticker is a tools to locate stickers"
 }
 ],
 "key_words": [
 {
 "fr": "LMS, LocateMyStickers, Locate My Stickers, tracking, live, sticker",
 "en": "LMS, LocateMyStickers, Locate My Stickers, tracking, live, sticker"
 }
 ]
 }
 */

@end
