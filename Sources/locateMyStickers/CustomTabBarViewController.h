//
//  CustomTabBarViewController.h
//  locatemystickers
//
//  Created by Adrien Guffens on 10/29/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarProtocol.h"

@interface CustomTabBarViewController : UITabBarController

@property(nonatomic, strong)UIImage *buttonImage;
@property(nonatomic, strong)UIImage *highlightImage;
@property(nonatomic, strong)id<CustomTabBarProtocol> delegate;

- (id)initWithButtonImageName:(NSString *)imageName  highlightImageName:(NSString *)highlightImageName;

@end
