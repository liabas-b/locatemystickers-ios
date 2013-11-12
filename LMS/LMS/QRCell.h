//
//  QRCell.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "LMSCell.h"
#import "LMSImageView.h"

@interface QRCell : LMSCell

@property (strong, nonatomic) IBOutlet LMSImageView *qrImageView;

- (void)configureQrCodeWithValue:(NSString *)value;

@end
