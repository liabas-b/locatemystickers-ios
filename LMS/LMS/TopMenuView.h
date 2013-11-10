//
//  TopMenuView.h
//  LMS
//
//  Created by Adrien Guffens on 09/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSView.h"
#import "LMSImageView.h"
#import "LMSLabel.h"

@interface TopMenuView : LMSView

@property (nonatomic, strong) IBOutlet LMSImageView *appImageView;
@property (nonatomic, strong) IBOutlet LMSLabel *appNameLabel;

@end
