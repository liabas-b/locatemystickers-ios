//
//  StickerCell.h
//  LMS
//
//  Created by Adrien Guffens on 2/25/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BButton;

@interface StickerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *iconLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activatedImage;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet BButton *mapButton;

- (IBAction)handlerMapButton:(id)sender;

@end
