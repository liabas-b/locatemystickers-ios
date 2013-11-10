//
//  LMSMenuCell.h
//  LMS
//
//  Created by Adrien Guffens on 08/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedImageView.h"
#import "LMSLabel.h"

@interface LMSMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet RoundedImageView *menuImageView;
@property (strong, nonatomic) IBOutlet LMSLabel *menuLabel;

@end
