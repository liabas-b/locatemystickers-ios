//
//  FriendsCollectionViewCell.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSCollectionViewCell.h"
#import "FriendImageView.h"
#import "LMSLabel.h"

@interface FriendsCollectionViewCell : LMSCollectionViewCell

@property (strong, nonatomic) IBOutlet FriendImageView *friendImageView;
@property (strong, nonatomic) IBOutlet LMSLabel *nameLabel;

@end
