//
//  LMSViewController.h
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

//#import <GAITrackedViewController.h>

@class AppDelegate;

@interface LMSViewController : UIViewController /*GAITrackedViewController*/

- (void)configure;

- (void)configureView;
- (void)setupData;

- (void)registerNibs;
- (void)setupView;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end
