//
//  FriendsCollection.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "FriendsCollectionView.h"
#import "FriendsCollectionViewCell.h"
#import "User.h"

#import "UIImageView+AFNetworking.h"

static NSString *CellIdentifier = @"FriendsCollectionViewCell";

@interface FriendsCollectionView ()

@property (nonatomic, strong) NSMutableArray *friendList;

@end

@implementation FriendsCollectionView

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
	self.dataSource = self;
	self.delegate = self;
	/*
	self.friendList = [[NSMutableArray alloc] init];
	
	[self.friendList addObject:@"adril"];
	[self.friendList addObject:@"ben"];
	[self.friendList addObject:@"hermes"];
	
	[self.friendList addObject:@"denis"];
	[self.friendList addObject:@"sylvain"];
	[self.friendList addObject:@"yann"];
	[self.friendList addObject:@"irfane"];
	
	[self reloadData];
	 */
}

- (void)configureWithFriendList:(NSArray *)friendList {
	[self.friendList removeAllObjects];
	self.friendList = [[NSMutableArray alloc] initWithArray:friendList];
	[self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.friendList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	FriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
//	NSString *identifier = [self.friendList objectAtIndex:indexPath.row];
	User *friend = [self.friendList objectAtIndex:indexPath.row];
	
	NSString *hashGravatar = [friend.email MD5];
	NSString *gravatarUrl = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@", hashGravatar];
	
	cell.nameLabel.text = friend.name;
	[cell.friendImageView setImageWithURL:[NSURL URLWithString:gravatarUrl] placeholderImage:[UIImage imageNamed:@"lms-300.png"]];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self performSelector:@selector(deselectCell:) withObject:indexPath afterDelay:0.5];
	
	//	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	User *friend = [self.friendList objectAtIndex:indexPath.row];
	
	if (self.touchHandler) {
		self.touchHandler(friend);
	}
}

- (void)deselectCell:(id)sender {
	NSIndexPath *indexPath = (NSIndexPath *)sender;
	
	[self deselectItemAtIndexPath:indexPath animated:YES];
}

@end
