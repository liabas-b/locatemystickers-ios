//
//  UserToolView.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSView.h"
#import "LMSLabel.h"

@interface UserToolView : LMSView

@property (nonatomic, strong) IBOutlet LMSLabel *nameLabel;
@property (nonatomic, strong) IBOutlet LMSLabel *quantityLabel;

- (void)configureName:(NSString *)name quantity:(NSString *)quantity;

- (void)selected;
- (void)unselected;

@end
