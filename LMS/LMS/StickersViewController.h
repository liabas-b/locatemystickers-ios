//
//  StickersViewController.h
//  LMS
//
//  Created by Adrien Guffens on 10/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSViewController.h"
#import "LMSTableView.h"
#import "StickerCell.h"
#import "ZBarSDK.h"

@interface StickersViewController : LMSViewController <UITableViewDataSource, UITableViewDelegate, MCSwipeStickerTableViewCellDelegate, ZBarReaderDelegate>

@property (strong, nonatomic) IBOutlet LMSTableView *tableView;

- (IBAction)scanHandler:(id)sender;

@end
