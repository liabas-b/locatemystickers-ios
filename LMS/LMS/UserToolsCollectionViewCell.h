//
//  UserToolsCollectionCell.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSCollectionViewCell.h"
#import "UserToolView.h"

@interface UserToolsCollectionViewCell : LMSCollectionViewCell

@property (strong, nonatomic) IBOutlet UserToolView *userToolsView;

@end
