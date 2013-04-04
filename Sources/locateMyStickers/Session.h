//
//  Session.h
//  AB
//
//  Created by Adrien Guffens on 1/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LROAuth2Client.h"
#import "LROAuth2AccessToken.h"

@interface Session : NSObject

@property (nonatomic, strong) LROAuth2Client *oauthClient;
@property (nonatomic, assign) BOOL isAuthentified;
@property (nonatomic, strong) NSDate *dateBackground;

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;

@end
