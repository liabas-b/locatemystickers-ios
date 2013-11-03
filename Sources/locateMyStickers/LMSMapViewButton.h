//
//  LMSMapViewButton.h
//  LMS
//
//  Created by Adrien Guffens on 02/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSMapBaseView.h"

@interface LMSMapViewButton : LMSMapBaseView

@property (nonatomic, strong) IBOutlet UIImageView *buttonImageView;
@property (nonatomic, strong) IBOutlet UILabel *buttonLabel;

- (void)setButtonImage:(UIImage *)image withButtonValue:(NSString *)buttonValue;

@end
