//
//  ApiKeys.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol ApiKeys
@end

@interface ApiKeys : JSONModel

@property (strong, nonatomic) NSString *facebookApiKey;
@property (strong, nonatomic) NSString *facebookAppSecret;
@property (strong, nonatomic) NSString *googleAnalyticsApiKey;
@property (strong, nonatomic) NSString *twitterOauthAccessToken;
@property (strong, nonatomic) NSString *twitterOauthAccessTokenSecret;
@property (strong, nonatomic) NSString *twitterConsumerKey;
@property (strong, nonatomic) NSString *twitterConsumerSecret;
@property (strong, nonatomic) NSString *pusherApiKey;

@end
