//
//  LMSMapCollectionViewCell.h
//  LMS
//
//  Created by Adrien Guffens on 10/13/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMSMapCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;

@end
