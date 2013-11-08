//
//  UserTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 2/24/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSTableViewController.h"
#import <QREncoder.h>
//#import "qrencode.h"

@interface UserTableViewController : LMSTableViewController

@property (strong, nonatomic) IBOutlet UILabel *yourStickersLabel;
@property (strong, nonatomic) IBOutlet UILabel *sharringStickersLabel;
@property (strong, nonatomic) IBOutlet UILabel *historiesLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *logoutLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end
