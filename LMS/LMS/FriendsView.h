//
//  FriendsView.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSView.h"
#import "FriendsCollectionView.h"
#import "LMSLabel.h"

@interface FriendsView : LMSView

@property (nonatomic, strong) IBOutlet FriendsCollectionView *friendsCollectionView;
@property (nonatomic, strong) IBOutlet LMSLabel *friendsLabel;

- (void)configureWithFriendList:(NSArray *)friendList;

@end
