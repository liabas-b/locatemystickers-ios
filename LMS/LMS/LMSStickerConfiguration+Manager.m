//
//  LMSStickerConfiguration+Manager.m
//  LMS
//
//  Created by Adrien Guffens on 07/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSStickerConfiguration+Manager.h"

@implementation LMSStickerConfiguration (Manager)

- (void)debug {
	DLog(@"activate: %@ - configurationId: %@ - createdAt: %@ - frequencyUpdate: %@ - stickerCode: %@ - updatedAt: %@", self.activate, self.configurationId, self.createdAt, self.frequencyUpdate, self.stickerCode, self.updatedAt);
}

@end
