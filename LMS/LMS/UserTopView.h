//
//  UserTopView.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSView.h"
#import "UserImageView.h"
#import "LMSLabel.h"
#import "User.h"

@interface UserTopView : LMSView

@property (nonatomic, strong) IBOutlet UserImageView *userImageView;
@property (nonatomic, strong) IBOutlet LMSLabel *nameLabel;
@property (nonatomic, strong) IBOutlet LMSLabel *userNameLabel;

- (void)configureWithUser:(User *)user;

@end
