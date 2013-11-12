//
//  UserTopView.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UserTopView.h"
#import "UIImageView+AFNetworking.h"

@implementation UserTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self configure];
}

- (void)configure {
	
	self.nameLabel.font = [UIFont defaultTitleFont];
	self.userNameLabel.font = [UIFont defaultSubtitleFont];

	self.nameLabel.textColor = [UIColor defaultFontColor];
	self.userNameLabel.textColor = [UIColor defaultFontColor];
	
	self.userImageView.image = [UIImage imageNamed:@"lms-300.png"];
	self.nameLabel.text = @"";
	self.userNameLabel.text = @"";
	
	[self layoutIfNeeded];
}

- (void)configureWithUser:(User *)user {
	
	NSString *hashGravatar = [user.email MD5];
	NSString *gravatarUrl = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", hashGravatar];
	
	[self.userImageView setImageWithURL:[NSURL URLWithString:gravatarUrl] placeholderImage:self.userImageView.image];

	NSString *userName =[NSString stringWithFormat:@"@%@", user.city];
	self.nameLabel.text = user.name;
	self.userNameLabel.text = userName;
}

@end
