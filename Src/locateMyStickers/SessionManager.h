//
//  ABSessionManager.h
//  AB
//
//  Created by Adrien Guffens on 1/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

#import "PopUpLoginView.h"

#import "LROAuth2ClientDelegate.h"
#import "SessionDelegate.h"

typedef enum SessionState {
	authentication,
	authenticated,
	unAuthenticated,
	errorAuthentication
} SessionState;

@interface SessionManager : NSObject <LROAuth2ClientDelegate, UIWebViewDelegate>

@property (nonatomic, strong) Session *session;
@property (nonatomic, assign) SessionState sessionState;
@property (nonatomic, strong) NSTimer *authenticationTimer;
@property (nonatomic, strong) id<SessionDelegate> delegate;

- (void)setupSessionWithClientID:(NSString *)clientID secret:(NSString *)secret redirectURL:(NSURL *)redirectURL;

- (void)setUserURL:(NSURL *)userURL;
- (void)setTokenURL:(NSURL *)tokenURL;

//- (void)authorizeUsingWebView:(UIWebView *)webView;
- (void)authorizeUsingPopupLoginView:(PopUpLoginView *)popUpLoginView;
- (BOOL)isAuthentified;
- (NSString *)accessToken;

- (void)setLogin:(NSString *)login andPassword:(NSString *)password;
- (void)loadAccessToken;

- (void)logout;

@end
