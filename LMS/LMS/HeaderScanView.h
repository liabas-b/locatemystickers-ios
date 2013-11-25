//
//  HeaderScanView.h
//  LMS
//
//  Created by Adrien Guffens on 25/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HeaderScanViewHandler)(id object);

@interface HeaderScanView : UIView

@property (nonatomic, assign) HeaderScanViewHandler backHandler;

@end
