//
//  QRCell.m
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "QRCell.h"
#import <QREncoder.h>

@implementation QRCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureQrCodeWithValue:(NSString *)value {
	DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:value];
    UIImage *qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:182];
    
	self.qrImageView.image = qrcodeImage;
}

@end
