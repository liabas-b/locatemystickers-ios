//
//  SessionManager.m
//  AB
//
//  Created by Adrien Guffens on 1/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "SessionManager.h"
#import "AppDelegate.h"


static NSString* const keyLoginResult = @"loginResult";

@interface SessionManager ()

@property (nonatomic, strong)PopUpLoginView* popupLoginView;

@end

@implementation SessionManager

- (id)initWithHostName:(NSString *)hostName {
	self = [super init];
	if(self) {
		self.session = [Session new];
		self.session.hostName = hostName;
	}
	return self;
}

- (void)setupSessionWithClientID:(NSString *)clientID secret:(NSString *)secret redirectURL:(NSURL *)redirectURL {
	
	self.session.oauthClient = [[LROAuth2Client alloc] initWithClientID:clientID secret:secret redirectURL:redirectURL];
	self.session.oauthClient.delegate = self;
}

- (void)setUserURL:(NSURL *)userURL {
	self.session.oauthClient.userURL = userURL;
}

- (void)setTokenURL:(NSURL *)tokenURL {
	self.session.oauthClient.tokenURL = tokenURL;
}

- (void)authorizeUsingWebView:(UIWebView *)webView {
	//TODO: check if already authorized
	self.sessionState = unAuthenticated;
	
	[self.session.oauthClient authorizeUsingWebView:webView];
}

- (void)authorizeUsingPopupLoginView:(PopUpLoginView *)popupLoginView {
	self.session.oauthClient.delegate = self;
	self.popupLoginView = popupLoginView;
	[self authorizeUsingWebView:popupLoginView.webView];
}

- (BOOL)isAuthentified {
	return self.sessionState == authenticated;
}

- (NSString *)accessToken {
	return self.session.oauthClient.accessToken.accessToken;
}

- (void)setLogin:(NSString *)login andPassword:(NSString *)password {
	
	self.session.login = login;
	self.session.password = password;
}

- (void)loadAccessToken {
	//TODO: load from file [OK]
	//INFO: if valid self.sessionState = authenticated;
	//TODO: get login & password from db
	
	NSURL *accessTokenFileUrl = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"accessToken"];
	
	LROAuth2AccessToken *token = [NSKeyedUnarchiver unarchiveObjectWithFile:[accessTokenFileUrl path]];
	
	if (token) {
		self.sessionState = authenticated;
		self.session.isAuthentified = YES;
		self.session.oauthClient.accessToken = token;
		//[[NSNotificationCenter defaultCenter] postNotificationName:keyLoginResult object:self];
		
		if ([self.delegate respondsToSelector:@selector(didReceiveValidToken)])
			[self.delegate didReceiveValidToken];
		
		
		//INFO: may be check if login are the same
		/*
		 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.bloc.net/2/account/me.json"]];
		 [request setHTTPMethod:@"GET"];
		 [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		 [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		 [request setValue:[NSString stringWithFormat:@"bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
		 
		 [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err){
		 //[self didReceiveData:data];
		 NSLog(@"data error: %@", err);
		 NSLog(@"NSURLResponse: %@", res);
		 }];
		 */
		
	}
	
}

- (void)logout {
	//TODO: remove the file [OK]
	self.sessionState = unAuthenticated;
	self.session.isAuthentified = NO;
	
	NSURL *accessTokenFileUrl = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"accessToken"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtURL:accessTokenFileUrl error:NULL];
}

#pragma mark - LROAuth2ClientDelegate

- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client {
	
	LROAuth2AccessToken *token = client.accessToken;
	
	if ([token.accessToken length] > 0) {
		
		[self.authenticationTimer invalidate];
		
		self.sessionState = authenticated;
		self.session.isAuthentified = YES;
		//[[NSNotificationCenter defaultCenter] postNotificationName:keyLoginResult object:self];
		
		//INFO: notify Valid Token
		if ([self.delegate respondsToSelector:@selector(didReceiveValidToken)])
			[self.delegate didReceiveValidToken];
		
		
		//INFO: save token
		NSURL *accessTokenFileUrl = [[AppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"accessToken"];
		BOOL success = [NSKeyedArchiver archiveRootObject:token toFile:[accessTokenFileUrl path]];
		if (success == YES) {
			//NSLog(@"success archiving Token");
		}
	}
	
}

- (void)oauthClientDidCancel:(LROAuth2Client *)client {
	self.sessionState = unAuthenticated;
	//INFO: notify Bad Token
	if ([self.delegate respondsToSelector:@selector(didReceiveBadToken)])
		[self.delegate didReceiveBadToken];
}

- (void)checkAccessTokenForExpiry:(LROAuth2AccessToken *)accessToken; {
	if ([accessToken hasExpired]) {
		[self.session.oauthClient refreshAccessToken:accessToken];
	}
}

- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client {
#ifdef DEBUG
	NSLog(@"Refresh");
#endif
	[self oauthClientDidReceiveAccessToken:client];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
#ifdef DEBUG
	NSLog(@"- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest: %@", request);
#endif
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
#ifdef DEBUG
	NSLog(@"- (void)webViewDidStartLoad");
#endif
	[self.popupLoginView.activityIndocator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
#ifdef DEBUG
	NSLog(@"- (void)webViewDidFinishLoad");
#endif
	[self.popupLoginView.activityIndocator stopAnimating];
	
	if (self.sessionState == unAuthenticated) {
		NSString *loginFieldString = [NSString stringWithFormat:@"document.getElementById('session_email').value = '%@'", self.session.login];
		[webView stringByEvaluatingJavaScriptFromString:loginFieldString];
		
		
		//INFO: debug
		//[webView stringByEvaluatingJavaScriptFromString:@"alert(document.getElementById('session_email').value)"];
		
		
		NSString *passwordFieldString = [NSString stringWithFormat:@"document.getElementById('session_password').value = '%@'", self.session.password];
		[webView stringByEvaluatingJavaScriptFromString:passwordFieldString];
		
		//INFO: debug
		//[webView stringByEvaluatingJavaScriptFromString:@"alert(document.getElementById('session_password').value)"];
		
		NSString *setSubmitValueString = @"document.forms[0].submit(); document.getElementByTagName('commit').onclick();";//Sign in
		[webView stringByEvaluatingJavaScriptFromString:setSubmitValueString];
		self.sessionState = authentication;
	}
	else if (self.sessionState == authentication) {
		/*
		 NSString *setSubmitValueString = @"document.forms[0].UserId.checked=true; document.getElementsByName('IsApproved')[0].value = true; document.forms[0].submit();";
		 [webView stringByEvaluatingJavaScriptFromString:setSubmitValueString];
		 
		 self.authenticationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(handleTimeAuthenticationTimer) userInfo:nil repeats:NO];
		 [[NSRunLoop mainRunLoop] addTimer:self.authenticationTimer forMode:NSRunLoopCommonModes];
		 */
	}
	else {
#ifdef DEBUG
		NSLog(@"ERROR Login");
#endif
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
#ifdef DEBUG
	NSLog(@"- (void)webView:(UIWebView *)webView didFailLoadWithError: %@", error);
#endif
	[self.popupLoginView.activityIndocator stopAnimating];
	
	/*
	 // Ignore NSURLErrorDomain error -999.
	 if (error.code == NSURLErrorCancelled)
	 return;
	 
	 // Ignore "Fame Load Interrupted" errors. Seen after app store links.
	 if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) {
	 return;
	 }
	 */
	
	if ([self.delegate respondsToSelector:@selector(didGetWebViewError:)])
		[self.delegate didGetWebViewError:error];
	
	[self.authenticationTimer invalidate];
	
	self.sessionState = errorAuthentication;
	self.session.isAuthentified = NO;
}

#pragma mark - handle

- (void)handleTimeAuthenticationTimer {
#ifdef DEBUG
	NSLog(@"Authentication error");
#endif
	self.sessionState = unAuthenticated;
	[[NSNotificationCenter defaultCenter] postNotificationName:keyLoginResult object:self];
	
#warning check langage & more
	
	//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" message:@"Failed to logg in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//	[alert show];
}


@end
