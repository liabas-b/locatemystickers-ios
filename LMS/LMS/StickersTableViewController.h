//
//  StickersTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSTableViewController.h"
#import "StickerCell.h"

//@class OptionsRecord;
//@class StickerRecord;

@interface StickersTableViewController : LMSTableViewController <MCSwipeStickerTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *stickerList;
//@property (nonatomic, strong) NSMutableArray *myPhonedList;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;
//@property (nonatomic, strong) OptionsRecord *optionsRecord;
//@property (nonatomic, strong) StickerRecord *stickerRecord;

@end
