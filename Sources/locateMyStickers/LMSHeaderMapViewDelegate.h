//
//  LMSHeaderMapViewDelegate.h
//  LMS
//
//  Created by Adrien Guffens on 03/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMSHeaderMapViewDelegate <NSObject>

- (void)didToggleStickerButton:(id)sender;
- (void)didToggleFriendButton:(id)sender;

@end
