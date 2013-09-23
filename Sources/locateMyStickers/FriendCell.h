//
//  FriendCell.h
//  LMS
//
//  Created by Adrien Guffens on 9/20/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stickersNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@end
