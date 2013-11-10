//
//  SocialsCollectionView.m
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "SocialsCollectionView.h"
#import "SocialCollectionViewCell.h"

static NSString *CellIdentifier = @"SocialCollectionViewCell";

@interface SocialsCollectionView ()

@property (nonatomic, strong) NSMutableArray *socialList;

@end

@implementation SocialsCollectionView

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
	
	self.socialList = [[NSMutableArray alloc] init];
	
	[self.socialList addObject:@"facebook"];
	[self.socialList addObject:@"google"];
	[self.socialList addObject:@"twitter"];
	
	[self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.socialList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SocialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

	NSString *identifier = [self.socialList objectAtIndex:indexPath.row];
	if ([identifier isEqualToString:@"facebook"]) {
		cell.socialImageView.image = [UIImage imageNamed:@"facebook-icon"];
	}
	else if ([identifier isEqualToString:@"google"]) {
		cell.socialImageView.image = [UIImage imageNamed:@"google-icon"];
	}
	else if ([identifier isEqualToString:@"twitter"]) {
		cell.socialImageView.image = [UIImage imageNamed:@"twitter-icon"];
	}

	return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
