//
//  FriendsCell.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSCell.h"
#import "FriendsCollectionView.h"

@interface FriendsCell : LMSCell

@property (strong, nonatomic) IBOutlet FriendsCollectionView *friendsCollectionView;

- (void)configureWithFriendList:(NSArray *)friendList;

@end
