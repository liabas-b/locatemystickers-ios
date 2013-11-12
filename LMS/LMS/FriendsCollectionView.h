//
//  FriendsCollection.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSCollectionView.h"

typedef void (^FriendToolsTouchHandler)(id object);

@interface FriendsCollectionView : LMSCollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)configureWithFriendList:(NSArray *)friendList;

@property (nonatomic, strong)FriendToolsTouchHandler touchHandler;

@end
