//
//  UserToolsCollectionView.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "UserToolsCollectionView.h"
#import "UserToolsCollectionViewCell.h"

static NSString *CellIdentifier = @"UserToolsCollectionViewCell";

@interface UserToolsCollectionView ()

@property (nonatomic, strong) NSMutableArray *userToolsList;

@end

@implementation UserToolsCollectionView

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
	self.touchHandler = nil;
	
	self.userToolsList = [[NSMutableArray alloc] init];
	
	[self.userToolsList addObject:@"followers"];
	[self.userToolsList addObject:@"following"];
	[self.userToolsList addObject:@"stickers"];
	
	[self reloadData];
}

- (void)configureUserToolsTouchHandler:(UserToolsTouchHandler)touchHandler {
	self.touchHandler = touchHandler;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.userToolsList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UserToolsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	cell.backgroundColor = [UIColor redColor];
	
	NSString *identifier = [self.userToolsList objectAtIndex:indexPath.row];
	
	if ([identifier isEqualToString:@"followers"]) {
		[cell.userToolsView configureName:[identifier uppercaseString] quantity:[@"2 k" uppercaseString]];
	}
	else if ([identifier isEqualToString:@"following"]) {
		[cell.userToolsView configureName:[identifier uppercaseString] quantity:[@"42 k" uppercaseString]];
	}

	else if ([identifier isEqualToString:@"stickers"]) {
		[cell.userToolsView configureName:[identifier uppercaseString] quantity:[@"24" uppercaseString]];
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self performSelector:@selector(deselectCell:) withObject:indexPath afterDelay:0.5];
//	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	NSString *identifier = [self.userToolsList objectAtIndex:indexPath.row];
	
	if (self.touchHandler) {
		self.touchHandler(identifier);
	}
}

- (void)deselectCell:(id)sender {
	NSIndexPath *indexPath = (NSIndexPath *)sender;
	
	[self deselectItemAtIndexPath:indexPath animated:YES];
}

@end
