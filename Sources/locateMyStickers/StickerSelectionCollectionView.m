//
//  StickerSelectionCollectionView.m
//  LMS
//
//  Created by Adrien Guffens on 10/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "StickerSelectionCollectionView.h"

@implementation StickerSelectionCollectionView

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
	
	//WARNING: could be bad
	self.stickerList = [[NSMutableArray alloc] init];
}

- (void)configureWithStickerList:(NSArray *)stickerList {
	self.stickerList = stickerList;
	
	//self
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
