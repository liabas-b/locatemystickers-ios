//
//  UserToolsCollectionView.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSCollectionView.h"

typedef void (^UserToolsTouchHandler)(NSString *identifier);

@interface UserToolsCollectionView : LMSCollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UserToolsTouchHandler touchHandler;

//INFO: to delete
- (void)configureUserToolsTouchHandler:(UserToolsTouchHandler)touchHandler;

@end
