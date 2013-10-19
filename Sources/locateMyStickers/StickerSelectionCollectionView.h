//
//  StickerSelectionCollectionView.h
//  LMS
//
//  Created by Adrien Guffens on 10/19/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerSelectionCollectionView : UICollectionView

@property (nonatomic, strong)NSMutableArray *stickerList;

- (void)configureWithStickerList:(NSArray *)stickerList;

@end
