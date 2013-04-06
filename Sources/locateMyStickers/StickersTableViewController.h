//
//  StickersTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsRecord;
@class StickerRecord;

@interface StickersTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *stickersRecordList;
@property (nonatomic, strong) NSMutableArray *myPhoneStickerRecordList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) OptionsRecord *optionsRecord;
@property (nonatomic, strong) StickerRecord *stickerRecord;

+ (NSDate *)getDate:(NSString *)date withFormat:(NSString *)format;

@end
