//
//  UserCell.h
//  LMS
//
//  Created by Adrien Guffens on 3/2/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerCell.h"

@class UserCell;

@protocol MCSwipeUserTableViewCellDelegate <NSObject>

@optional
- (void)swipeUserTableViewCell:(UserCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode;
- (void)swipeUserTableViewCell:(UserCell *)cell didTriggerButtonState:(MCSwipeTableViewButtonState)buttonState;

@end


@interface UserCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stickersNumberLabel;


@property(nonatomic, assign) id <MCSwipeUserTableViewCellDelegate> delegate;
/*
@property (strong, nonatomic) IBOutlet UILabel *iconLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activatedImage;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet BButton *mapButton;

- (IBAction)handlerMapButton:(id)sender;
*/
@property(nonatomic, assign) BOOL isActif;

//INFO: menu view stuff
@property(nonatomic, copy) NSString *firstIconName;
@property(nonatomic, copy) NSString *secondIconName;
@property(nonatomic, copy) NSString *thirdIconName;
@property(nonatomic, copy) NSString *fourthIconName;

@property(nonatomic, strong) UIColor *firstColor;
@property(nonatomic, strong) UIColor *secondColor;
@property(nonatomic, strong) UIColor *thirdColor;
@property(nonatomic, strong) UIColor *fourthColor;

@property(nonatomic, assign) MCSwipeTableViewCellMode mode;

- (id)initWithStyle:(UITableViewCellStyle)style
reuseIdentifier:(NSString *)reuseIdentifier
firstStateIconName:(NSString *)firstIconName
firstColor:(UIColor *)firstColor
secondStateIconName:(NSString *)secondIconName
secondColor:(UIColor *)secondColor
thirdIconName:(NSString *)thirdIconName
thirdColor:(UIColor *)thirdColor
fourthIconName:(NSString *)fourthIconName
fourthColor:(UIColor *)fourthColor;

- (void)setFirstStateIconName:(NSString *)firstIconName
firstColor:(UIColor *)firstColor
secondStateIconName:(NSString *)secondIconName
secondColor:(UIColor *)secondColor
thirdIconName:(NSString *)thirdIconName
thirdColor:(UIColor *)thirdColor
fourthIconName:(NSString *)fourthIconName
fourthColor:(UIColor *)fourthColor;

- (void)bounceToOrigin;
@end
