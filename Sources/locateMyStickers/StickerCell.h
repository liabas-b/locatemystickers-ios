//
//  StickerCell.h
//  LMS
//
//  Created by Adrien Guffens on 2/25/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activatedImage;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)handlerMapButton:(id)sender;

@end
