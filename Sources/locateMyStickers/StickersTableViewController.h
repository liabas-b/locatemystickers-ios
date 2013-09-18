//
//  StickersTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "StickerCell.h"

@class OptionsRecord;
@class StickerRecord;

@interface StickersTableViewController : BaseTableViewController <MCSwipeStickerTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *stickersRecordList;
@property (nonatomic, strong) NSMutableArray *myPhoneStickerRecordList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) OptionsRecord *optionsRecord;
@property (nonatomic, strong) StickerRecord *stickerRecord;

@end
